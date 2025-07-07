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

final class WalkCourseViewModel: ObservableObject {
    private let locationManager: LocationManager
    @Published var currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    @Published var pathCoordinates: [CLLocationCoordinate2D] = []
    @Published var isTracking: Bool = false
    @Published var shouldCenterOnUser: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
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
                

                
                if self.isTracking {
                    self.pathCoordinates.append(coordinate)
                }
            }
            .store(in: &cancellables)
    }
    
    func startTracking() {
        isTracking = true
        pathCoordinates = []
        locationManager.startUpdating()
    }
    
    func stopTracking() {
        isTracking = false
        locationManager.stopUpdating()
    }
    
    func requestPermission() {
        locationManager.requestLocationPermission()
    }
    
    func centerMapOnCurrentLocation() {     
        guard locationManager.currentLocation != nil else { return }
                shouldCenterOnUser = true
    }

}
