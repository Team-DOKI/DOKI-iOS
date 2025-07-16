//
//  WalkCourseViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import Foundation
import MapKit
import SwiftUI
import Combine
import CoreMotion
import Moya

final class WalkCourseViewModel: ObservableObject {
    private let locationManager: LocationManager
    private let provider = MoyaProvider<WalkCourseAPI>()
    private let pedometer = CMPedometer()
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private var startTime: Date?
    private var pauseTime: Date?
    private var accumulatedPauseTime: TimeInterval = 0
    private var previousLocation: CLLocation?
    
    @Published var currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @Published var pathCoordinates: [CLLocationCoordinate2D] = []
    @Published var isTracking: Bool = false
    @Published var shouldCenterOnUser: Bool = true
    @Published var shouldFollowUser: Bool = true
    @Published var isPaused: Bool = false
    @Published var distance: Double = 0.0
    @Published var elapsedTime: String = "00:00"
    @Published var stepCount: Int = 0
    
    @Published var selectedMode: MapAndListTab = .map
    @Published var showWalkCourseView = false
    @Published var userTrackingMode: MKUserTrackingMode = .none
    @Published var routeId: Int = 0
    
    init(locationManager: LocationManager = .shared) {
        self.locationManager = locationManager
        
        setupBindings()
    }
    
    // MARK: - 위치 Binding
    
    // 위치 변경 이벤트 구독 설정
    private func setupBindings() {
        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.handleLocationUpdate(location)
            }
            .store(in: &cancellables)
    }
    
    private func handleLocationUpdate(_ location: CLLocation) {
        let coordinate = location.coordinate
        
        // 지도 영역 이동
        if shouldFollowUser {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
        
        // 기록 중 & 일시정지 아님이면 경로 추가, 거리 갱신
        if isTracking && !isPaused {
            pathCoordinates.append(coordinate)
            updateDistance(with: location)
        }
    }
    
    func requestPermission() {
        locationManager.requestLocationPermission()
    }
    
    func centerMapOnCurrentLocation() {
        guard locationManager.currentLocation != nil else { return }
        shouldCenterOnUser = true
    }
    
    // MARK: - 트래킹 제어
    
    func startTracking() {
        isTracking = true
        isPaused = false
        resetTrackingData()
        
        locationManager.startUpdating()
        startPedometer()
        startTimer()
    }
    
    func stopTracking() {
        isTracking = false
        isPaused = false
        
        locationManager.stopUpdating()
        stopPedometer()
        stopTimer()
    }
    
    func setPaused(_ paused: Bool) {
        if paused {
            isPaused = true
            pauseTime = Date()
        } else {
            isPaused = false
            if let pauseTime = pauseTime {
                accumulatedPauseTime += Date().timeIntervalSince(pauseTime)
                self.pauseTime = nil
            }
        }
    }
    
    func resetTrackingData() {
        pathCoordinates = []
        distance = 0.0
        stepCount = 0
        elapsedTime = "00:00"
        previousLocation = nil
        accumulatedPauseTime = 0
        pauseTime = nil
    }
    
    // MARK: - 거리/시간/걸음수
    
    // 두 위치 간 거리 계산해서 누적
    private func updateDistance(with newLocation: CLLocation) {
        if let previous = previousLocation {
            distance += newLocation.distance(from: previous) / 1000.0
        }
        previousLocation = newLocation
    }
    
    private func startPedometer() {
        guard CMPedometer.isStepCountingAvailable() else { return }
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let steps = data?.numberOfSteps, !self.isPaused {
                    self.stepCount = steps.intValue
                }
            }
        }
    }
    
    private func stopPedometer() {
        pedometer.stopUpdates()
    }
    
    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 경과 시간 업데이트
    private func updateElapsedTime() {
        guard let startTime = startTime, !isPaused else { return }
        
        let totalElapsed = Date().timeIntervalSince(startTime) - accumulatedPauseTime
        
        let elapsedSeconds = Int(totalElapsed)
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        
        elapsedTime = String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: - 스냅샷

extension WalkCourseViewModel {
    // 현재 경로를 기반으로 지도의 이미지 스냅샷 생성
    func captureMapSnapshot(completion: @escaping (UIImage?) -> Void) {
        guard !pathCoordinates.isEmpty else {
            completion(nil)
            return
        }
        
        let lats = pathCoordinates.map { $0.latitude }
        let lons = pathCoordinates.map { $0.longitude }
        
        guard let minLat = lats.min(),
              let maxLat = lats.max(),
              let minLon = lons.min(),
              let maxLon = lons.max() else {
            completion(nil)
            return
        }
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        
        var latSpan = maxLat - minLat
        var lonSpan = maxLon - minLon
        
        let minSpan = 0.0005
        latSpan = max(latSpan, minSpan)
        lonSpan = max(lonSpan, minSpan)
        
        let paddingFactor = 1.3
        latSpan *= paddingFactor
        lonSpan *= paddingFactor
        
        let contentWidth = (UIScreen.main.bounds.width - 32) * UIScreen.main.scale
        let imageWidth: CGFloat = contentWidth
        let imageHeight: CGFloat = 156 * UIScreen.main.scale
        
        let imageAspect = imageWidth / imageHeight
        let spanAspect = lonSpan / latSpan
        
        if spanAspect > imageAspect {
            latSpan = lonSpan / imageAspect
        } else {
            lonSpan = latSpan * imageAspect
        }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
        )
        
        // MKMapSnapshotter 옵션 설정
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: imageWidth, height: imageHeight)
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            // 스냅샷 이미지 위에 경로를 직접 그림
            UIGraphicsBeginImageContextWithOptions(options.size, true, 0)
            snapshot.image.draw(at: .zero)
            
            if self.pathCoordinates.count > 1 {
                let context = UIGraphicsGetCurrentContext()
                context?.setStrokeColor(UIColor.green500.cgColor)
                context?.setLineWidth(4.0 * UIScreen.main.scale)
                context?.setLineJoin(.round)
                context?.setLineCap(.round)
                
                let points = self.pathCoordinates.map { snapshot.point(for: $0) }
                context?.move(to: points.first!)
                for point in points.dropFirst() {
                    context?.addLine(to: point)
                }
                context?.strokePath()
            }
            
            // 최종 이미지 반환
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(finalImage)
        }
    }
}

//MARK: - API

extension WalkCourseViewModel {
    func postWalkCourse(snapshotImage: UIImage?) async {
        let coords = pathCoordinates.map {
            WalkCoordinateDTO(longitude: $0.longitude, latitude: $0.latitude)
        }
        
        guard let startTime = startTime else {
            return
        }
        
        let endTime = Date()
        let duration = Int(endTime.timeIntervalSince(startTime) - accumulatedPauseTime)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let body = WalkCourseRequestDTO(
            coordinates: coords,
            distance: Int(distance * 1000),
            duration: duration,
            startedAt: formatter.string(from: startTime),
            endedAt: formatter.string(from: endTime),
            stepCount: 100
        )
        
        let imageData = snapshotImage?.jpegData(compressionQuality: 0.8)
        
        do {
            let response: BaseDTO<WalkCourseResponseDTO> = try await provider.async.request(
                .postWalkCourse(body: body, image: imageData)
            )
            
            print("\(response.message)")
            print("""
        거리: \(distance)
        시간: \(duration)
        걸음 수: \(stepCount)
        """)
            
            guard let routeId = response.data?.routeId else {
                return
            }
            self.routeId = routeId
            
            print("routeId: \(routeId)")
            
        } catch {
            print("산책 루트 등록 실패: \(error.localizedDescription)")
        }
    }
}
