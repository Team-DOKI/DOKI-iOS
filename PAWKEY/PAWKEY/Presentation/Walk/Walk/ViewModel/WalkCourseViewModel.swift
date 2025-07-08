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
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @Published var pathCoordinates: [CLLocationCoordinate2D] = []
    @Published var isTracking: Bool = false
    @Published var shouldCenterOnUser: Bool = false
    @Published var isPaused: Bool = false
    
    @Published var distanceInKilometers: Double = 0.0
    @Published var elapsedTimeString: String = "00:00"
    @Published var stepCount: Int = 0

    init(locationManager: LocationManager = .shared) {
        self.locationManager = locationManager
        
        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self else { return }
                
                let coordinate = location.coordinate
                
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                
                if self.isTracking && !self.isPaused {
                    self.pathCoordinates.append(coordinate)
                    self.updateDistance(with: location)
                }
            }
            .store(in: &cancellables)
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

    func pauseTracking() {
        isPaused = true
        pauseTime = Date()
    }
    
    func resumeTracking() {
        isPaused = false
        if let pauseTime = pauseTime {
            accumulatedPauseTime += Date().timeIntervalSince(pauseTime)
            self.pauseTime = nil
        }
    }
    
    func requestPermission() {
        locationManager.requestLocationPermission()
    }
    
    func centerMapOnCurrentLocation() {
        guard locationManager.currentLocation != nil else { return }
        shouldCenterOnUser = true
    }
    
    private func resetTrackingData() {
        pathCoordinates = []
        distanceInKilometers = 0.0
        stepCount = 0
        elapsedTimeString = "00:00"
        previousLocation = nil
        accumulatedPauseTime = 0
        pauseTime = nil
    }
    
    private func updateDistance(with newLocation: CLLocation) {
        if let previous = previousLocation {
            let distance = newLocation.distance(from: previous)
            distanceInKilometers += distance / 1000.0
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
        
        elapsedTimeString = String(format: "%02d:%02d", minutes, seconds)
    }
}
