//
//  SharedWalkCourseViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/13/25.
//

import Foundation
import MapKit
import Combine
import SwiftUI
import CoreMotion
import Moya

final class SharedWalkCourseViewModel: ObservableObject {
    private let locationManager: LocationManager
    private let provider = MoyaProvider<SharedWalkCourseAPI>()
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
    
    var examplePathCoordinates: [CLLocationCoordinate2D] = []
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
    
    // MARK: - 위치 Binding
    
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
        
        if shouldFollowUser {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
        
        if isTracking && !isPaused {
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
        distance = 0.0
        stepCount = 0
        elapsedTime = "00:00"
        previousLocation = nil
        accumulatedPauseTime = 0
        pauseTime = nil
    }
    
    // MARK: - 거리/시간/걸음수
    
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
    
    private func updateElapsedTime() {
        guard let startTime = startTime, !isPaused else { return }
        
        let totalElapsed = Date().timeIntervalSince(startTime) - accumulatedPauseTime
        let elapsedSeconds = Int(totalElapsed)
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        
        elapsedTime = String(format: "%02d:%02d", minutes, seconds)
    }
}

//MARK: - API

extension SharedWalkCourseViewModel {
    @MainActor
    func fetchSharedWalkCourses(routeId: Int) async {
        do {
            let response: BaseDTO<SharedWalkCourseDTO> = try await provider.async.request(.fetchSharedWalkCourse(routeId: 55))
            
            guard let data = response.data?.geometryDto else {
                print("geometryDto 없음")
                return
            }
            
            let coordinates = parseCoordinates(from: data)
            
            print("받은 좌표:")
            let preview = coordinates.prefix(5).map { "(\($0.latitude), \($0.longitude))" }.joined(separator: ", ")
            let suffix = coordinates.count > 5 ? ", ..." : ""
            print("[\(preview)\(suffix)]")
            
            self.examplePathCoordinates = coordinates
            
            if let first = coordinates.first {
                self.region = MKCoordinateRegion(
                    center: first,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                self.shouldCenterOnUser = true
            }
        } catch {
            print("공유 루트 조회 실패: \(error.localizedDescription)")
        }
    }
    
    private func parseCoordinates(from geometry: GeometryDto) -> [CLLocationCoordinate2D] {
        return geometry.coordinates.compactMap { point in
            guard point.count == 2 else { return nil }
            let lon = point[0]
            let lat = point[1]
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
}
