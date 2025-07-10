//
//  WalkCourseViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import Foundation
import MapKit
import Combine
import SwiftUI
import CoreMotion

final class WalkCourseViewModel: ObservableObject {
    private let locationManager: LocationManager
    private let pedometer = CMPedometer()
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private var startTime: Date?
    private var pauseTime: Date?
    private var accumulatedPauseTime: TimeInterval = 0
    
    private var previousLocation: CLLocation?
    
    @Published var currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    @Published var region = MKCoordinateRegion( // 지도 영역
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @Published var pathCoordinates: [CLLocationCoordinate2D] = [] // 이동 경로 좌표
    @Published var isTracking: Bool = false
    @Published var shouldCenterOnUser: Bool = true
    @Published var shouldFollowUser: Bool = true
    @Published var isPaused: Bool = false
    
    @Published var distance: Double = 0.0
    @Published var elapsedTime: String = "00:00"
    @Published var stepCount: Int = 0
    
    init(locationManager: LocationManager = .shared) {
        self.locationManager = locationManager
        
        setupBindings()
    }
    
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
    
    func requestPermission() {
        locationManager.requestLocationPermission()
    }
    
    func centerMapOnCurrentLocation() {
        guard locationManager.currentLocation != nil else { return }
        shouldCenterOnUser = true
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

extension WalkCourseViewModel {
    // 현재 경로를 기반으로 지도의 이미지 스냅샷 생성
    func captureMapSnapshot(completion: @escaping (UIImage?) -> Void) {
        guard !pathCoordinates.isEmpty else {
            completion(nil)
            return
        }
        
        // 경로의 위도, 경도 min/max 계산
        // 경로가 보이도록 영역 설정
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
        
        // 영역 계산 + 최소값 보장
        var latSpan = maxLat - minLat
        var lonSpan = maxLon - minLon
        
        let minSpan = 0.0005
        latSpan = max(latSpan, minSpan)
        lonSpan = max(lonSpan, minSpan)
        
        // 패딩
        let paddingFactor = 1.3
        latSpan *= paddingFactor
        lonSpan *= paddingFactor
        
        // 스냅샷 이미지 사이즈 계산
        let contentWidth = (UIScreen.main.bounds.width - 32) * UIScreen.main.scale
        let imageWidth: CGFloat = contentWidth
        let imageHeight: CGFloat = 156 * UIScreen.main.scale
        
        // 이미지 비율과 영역 비율 맞추기
        let imageAspect = imageWidth / imageHeight
        let spanAspect = lonSpan / latSpan
        
        if spanAspect > imageAspect {
            latSpan = lonSpan / imageAspect
        } else {
            lonSpan = latSpan * imageAspect
        }
        
        // 최종 영역 설정
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
        )
        
        // MKMapSnapshotter 옵션 설정
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: imageWidth, height: imageHeight)
        options.scale = UIScreen.main.scale
        
        // 스냅샷 생성 시작
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
