//
//  FollowRouteViewModel.swift
//  DOKI
//
//  Created by 이세민 on 3/12/26.
//

import SwiftUI
import Combine
import CoreLocation
import CoreMotion

class FollowRouteViewModel: ObservableObject {
    private let routeAPIService: RouteAPIServiceProtocol
    private var routeId: Int?
    
    func setRoute(_ routeId: Int) {
        self.routeId = routeId
    }
    
    init(routeAPIService: RouteAPIServiceProtocol = RouteAPIService()) {
        self.routeAPIService = routeAPIService
    }
    
    @Published var pathCoordinates: [CLLocationCoordinate2D] = []
    @Published var currentLocation: CLLocation?
    
    @Published var userTrackingMode = false
    
    @Published var distance: Double = 0.0
    @Published var elapsedSeconds: Int = 0
    @Published var stepCount: Int = 0
    private(set) var startDate: Date = Date()
    
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
    
    var navigationAction: ((FollowRouteRoute) -> Void)?
    var skipReview: Bool = false
    
    func finishFollow() {
        navigateToFollowReview()
    }
    
    func navigateToFollowReview() {
        navigationAction?(.followRouteReview)
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
        startDate = Date()
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
        print("📏 최종 거리: \(distanceString)")
        print("👣 최종 걸음 수: \(stepCount)")
    }
    
    
    // MARK: - 걸음수
    
    func startStepCounting() {
        guard CMPedometer.isStepCountingAvailable(),
              !isPedometerRunning else { return }
        
        isPedometerRunning = true
        
        pedometer.startUpdates(from: Date()) { [weak self] data, _ in
            
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

// MARK: - API

extension FollowRouteViewModel {
    func fetchRouteGeometry() {
        guard let routeId else { return }
        
        routeAPIService.fetchRouteGeometry(routeId: routeId) { [weak self] result in
            
            switch result {
            case .success(let response):
                guard let coordinates = response?.data?.geometry.coordinates else { return }
                
                let converted = coordinates.map {
                    CLLocationCoordinate2D(
                        latitude: $0[1],
                        longitude: $0[0]
                    )
                }
                
                DispatchQueue.main.async {
                    self?.pathCoordinates = converted
                }
                
            default:
                print("루트 좌표 조회에 실패했습니다.")
            }
        }
    }
}
