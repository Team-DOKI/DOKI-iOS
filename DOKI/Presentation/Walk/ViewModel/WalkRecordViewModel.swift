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
    
    init(walkAPIService: WalkAPIServiceProtocol = WalkAPIService()) {
        self.walkAPIService = walkAPIService
    }
    
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
    
    func navigateToWalkResult(response: WalkFinishResponse?) {
        stopTimer()
        
        let resultData = WalkResultData(
            distance: distance,
            elapsedSeconds: elapsedSeconds,
            stepCount: stepCount
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
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.navigateToWalkResult(response: response?.data)
                    WalkSessionManager.shared.nRouteId = response?.data?.routeId
                }
                
            default:
                print("산책 종료 실패")
            }
        }
    }
}
