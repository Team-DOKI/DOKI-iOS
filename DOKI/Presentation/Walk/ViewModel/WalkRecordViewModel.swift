//
//  WalkRecordViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import Combine
import CoreLocation
import CoreMotion

class WalkRecordViewModel: ObservableObject {

    private let walkAPIService: WalkAPIServiceProtocol
    private let imageAPIService: ImageAPIServiceProtocol

    init(
        walkAPIService: WalkAPIServiceProtocol = WalkAPIService(),
        imageAPIService: ImageAPIServiceProtocol = ImageAPIService()
    ) {
        self.walkAPIService = walkAPIService
        self.imageAPIService = imageAPIService
    }

    /// WalkNaverMapView가 설정하는 지도 캡처 클로저 (Metal re-render 대기 후 completion)
    var captureMapAction: ((@escaping (UIImage?) -> Void) -> Void)?
    
    @Published var pathCoordinates: [CLLocationCoordinate2D] = []
    @Published var currentLocation: CLLocation?
    
    @Published var userTrackingMode = false
    
    @Published var distance: Double = 0.0
    @Published var elapsedSeconds: Int = 0
    @Published var stepCount: Int = 0
    
    private var isPaused: Bool = false
    
    private var timer: Timer?
    
    private var lastLocation: CLLocation?
    private let pedometer = CMPedometer()
    private var baseStepCount: Int = 0
    private var isPedometerRunning = false
    
    var distanceString: String {
        String(format: "%.2f", distance / 1000)
    }
    
    var elapsedTimeString: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var stepString: String {
        "\(stepCount)"
    }
    
    var navigationAction: ((WalkRecordRoute, WalkResultData?, WalkFinishResponse?) -> Void)?
    
    func navigateToWalkResult(response: WalkFinishResponse?, routeMapImage: UIImage?) {
        stopTimer()

        let resultData = WalkResultData(
            distance: distance,
            elapsedSeconds: elapsedSeconds,
            stepCount: stepCount,
            routeMapImage: routeMapImage
        )

        navigationAction?(.walkResult, resultData, response)
    }
    
    func reset() {
        elapsedSeconds = 0
        distance = 0.0
        stepCount = 0
        baseStepCount = 0
        lastLocation = nil
    }
    
    func updateLocation(_ newLocation: CLLocation) {
        guard !isPaused else { return }
        
        if let last = lastLocation {
            let delta = newLocation.distance(from: last)
            
            guard delta > 1 else { return }
            
            distance += delta
        }
        
        lastLocation = newLocation
        currentLocation = newLocation
    }
    
    
    // MARK: - 시간 (타이머)
    
    func startTimer() {
        isPaused = false
        timer?.invalidate()
        
        startStepCounting()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            
            self.elapsedSeconds += 1
        }
    }
    
    func pauseTimer() {
        isPaused = true
        pauseStepCounting()
    }
    
    func resumeTimer() {
        isPaused = false
        startStepCounting()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        stopStepCounting()
        lastLocation = nil
        
        print("🕒 최종 산책 시간: \(elapsedTimeString)")
        print("📏 최종 거리: \(distanceString)m")
        print("👣 최종 걸음 수: \(stepCount)")
    }
    
    // MARK: - 걸음수
    
    func startStepCounting() {
        guard CMPedometer.isStepCountingAvailable(),
              !isPedometerRunning else { return }
        
        isPedometerRunning = true
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self,
                  let steps = data?.numberOfSteps.intValue else { return }
            
            DispatchQueue.main.async {
                self.stepCount = self.baseStepCount + steps
            }
        }
    }
    
    func pauseStepCounting() {
        pedometer.stopUpdates()
        baseStepCount = stepCount
        isPedometerRunning = false
    }
    
    func stopStepCounting() {
        pedometer.stopUpdates()
        isPedometerRunning = false
    }
}

//MARK: - API

extension WalkRecordViewModel {
    /// 산책 종료
    func finishWalk() {
        guard let routeId = WalkSessionManager.shared.sRouteId else { return }

        WalkSessionManager.shared.stopStreaming()

        let formatter = ISO8601DateFormatter()
        let request = WalkFinishRequest(
            distance: distance,
            duration: elapsedSeconds,
            stepCount: stepCount,
            endedAt: formatter.string(from: Date())
        )

        walkAPIService.finishWalk(routeId: routeId, request: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    WalkSessionManager.shared.nRouteId = response?.data?.routeId

                    // Metal re-render 대기 후 캡처 → 완료되면 navigate
                    if let captureMapAction = self.captureMapAction {
                        captureMapAction { capturedImage in
                            self.navigateToWalkResult(response: response?.data, routeMapImage: capturedImage)
                            if let image = capturedImage {
                                self.uploadRouteImage(image)
                            }
                        }
                    } else {
                        self.navigateToWalkResult(response: response?.data, routeMapImage: nil)
                    }
                }
            default:
                print("산책 종료 실패")
            }
        }
    }

    private func uploadRouteImage(_ image: UIImage) {
        Task {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

            do {
                let presignedRequest = PresignedURLRequest(domain: "ROUTE", contentType: "image/jpeg")
                guard let presignedData = try await imageAPIService.asyncPresignedURL(request: presignedRequest).data,
                      let uploadURL = URL(string: presignedData.uploadUrl) else { return }

                var urlRequest = URLRequest(url: uploadURL)
                urlRequest.httpMethod = "PUT"
                urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = imageData
                _ = try await URLSession.shared.data(for: urlRequest)

                let registerRequest = RegisterImageRequest(
                    imageUrl: presignedData.imageUrl,
                    contentType: "image/jpeg",
                    width: Int(image.size.width),
                    height: Int(image.size.height),
                    domain: "ROUTE"
                )

                if let imageId = try await imageAPIService.asyncRegisterImage(request: registerRequest).data?.imageId {
                    WalkSessionManager.shared.routeImageId = imageId
                }
            } catch {
                print("경로 이미지 업로드 실패:", error.localizedDescription)
            }
        }
    }
}
