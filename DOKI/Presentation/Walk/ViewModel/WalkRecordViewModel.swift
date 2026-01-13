//
//  StartWalkViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI
import Combine
import CoreLocation
import CoreMotion

enum WalkReviewRoute {
    case walkResult
}

class WalkRecordViewModel: ObservableObject {
    
    @Published var pathCoordinates: [CLLocationCoordinate2D] = []
    @Published var currentLocation: CLLocation?
    
    @Published var userTrackingMode = false
    
    @Published var distance: Double = 0.0
    @Published var elapsedSeconds: Int = 0
    @Published var stepCount: Int = 0
    
    private var timer: Timer?
    private var isPaused: Bool = false
    
    var distanceString: String {
        String(format: "%.2f", distance)
    }
    
    var elapsedTimeString: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var stepString: String {
        "\(stepCount)"
    }
    
    func startTimer() {
        isPaused = false
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            
            self.elapsedSeconds += 1
        }
    }
    
    func pauseTimer() {
        isPaused = true
    }
    
    func resumeTimer() {
        isPaused = false
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        print("🕒🕒🕒 최종 산책 시간: \(elapsedTimeString) 🕒🕒🕒")
    }
    
    func reset() {
        elapsedSeconds = 0
        distance = 0.0
        stepCount = 0
    }
    
    var navigationAction: ((WalkReviewRoute)->())?
    
    func navigateToWalkResult() {
        stopTimer()
        navigationAction?(.walkResult)
    }
}
