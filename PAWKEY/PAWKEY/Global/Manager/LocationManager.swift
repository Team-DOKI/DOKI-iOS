//
//  LocationManager.swift
//  PAWKEY
//
//  Created by 권석기 on 7/7/25.
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
        setLocationManager()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 가장 높은수준의 정확도
    }
}
