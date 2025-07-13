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

final class SharedWalkCourseViewModel: ObservableObject {
    private let locationManager: LocationManager
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
    
    let examplePathCoordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.5887, longitude: 126.9346), // Swiss Grand Hotel 인근 :contentReference[oaicite:1]{index=1}
        CLLocationCoordinate2D(latitude: 37.5883, longitude: 126.9335), // 언덕길 아래쪽 진입 지점
        CLLocationCoordinate2D(latitude: 37.5878, longitude: 126.9325), // 골목길 중간
        CLLocationCoordinate2D(latitude: 37.5873, longitude: 126.9315), // 언덕 꼭대기 부근
        CLLocationCoordinate2D(latitude: 37.5868, longitude: 126.9305), // 다시 내려가는 길
        CLLocationCoordinate2D(latitude: 37.5863, longitude: 126.9295), // 언덕길 하단 복귀 지점
    ]
    
    
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
        distance = 0.0
        stepCount = 0
        elapsedTime = "00:00"
        previousLocation = nil
        accumulatedPauseTime = 0
        pauseTime = nil
    }
    
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
