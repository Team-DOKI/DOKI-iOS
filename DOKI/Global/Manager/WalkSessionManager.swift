//
//  WalkSessionManager.swift
//  DOKI
//
//  Created by 이세민 on 3/7/26.
//

import Foundation
import CoreLocation

final class WalkSessionManager {
    
    static let shared = WalkSessionManager()
    
    private init() {}
    
    var sRouteId: String?
    var nRouteId: Int?
    
    private let walkAPIService: WalkAPIServiceProtocol = WalkAPIService()
    
    private var streamTimer: Timer?
    
    // MARK: - 스트리밍 시작
    
    func startStreaming() {
        stopStreaming()
        
        streamTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.sendPoint()
        }
    }
    
    func stopStreaming() {
        streamTimer?.invalidate()
        streamTimer = nil
    }
    
    // MARK: - 좌표 전송 (API)
    
    func sendPoint() {
        guard let routeId = sRouteId else { return }
        guard let location = LocationManager.shared.currentLocation else { return }
        
        let request = WalkStreamRequest(
            routeId: routeId,
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude,
            timestamp: Int(Date().timeIntervalSince1970 * 1000)
        )
        
        walkAPIService.streamWalk(request: request) { result in
            switch result {
            case .success:
                break
            default:
                print("좌표 스트리밍 실패")
            }
        }
    }
}
