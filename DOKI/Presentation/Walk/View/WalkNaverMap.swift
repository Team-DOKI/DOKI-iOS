//
//  WalkNaverMap.swift
//  DOKI
//
//  Created by 이세민 on 1/9/26.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct WalkNaverMap: UIViewRepresentable {
    
    @Binding var pathCoordinates: [CLLocationCoordinate2D]
    @Binding var shouldCenterOnUser: Bool
    
    private let locationManager = CLLocationManager()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.locationOverlay.hidden = false
        mapView.positionMode = .direction
        
        context.coordinator.mapView = mapView
        
        return mapView
    }
    
    func updateUIView(_ mapView: NMFMapView, context: Context) {
        context.coordinator.updatePath(pathCoordinates)
    }
}

extension WalkNaverMap {
    class Coordinator: NSObject, CLLocationManagerDelegate {
        
        var parent: WalkNaverMap
        weak var mapView: NMFMapView?
        private var pathOverlay: NMFPath?
        private var lastLocation: CLLocation?
        private var didSetupLocationOverlay = false
        private var didMoveInitialCamera = false
        
        init(_ parent: WalkNaverMap) {
            self.parent = parent
        }
        
        func locationManager(
            _ manager: CLLocationManager,
            didUpdateLocations locations: [CLLocation]
        ) {
            guard let location = locations.last,
                  let mapView = mapView else { return }
            
            let overlay = mapView.locationOverlay
            
            if !didSetupLocationOverlay {
                overlay.hidden = false
                overlay.icon = NMFOverlayImage(image: UIImage(resource: .icMylocation))
                overlay.anchor = CGPoint(x: 0.5, y: 0.5)
                overlay.subIcon = nil
                overlay.circleRadius = 0
                didSetupLocationOverlay = true
            }
            
            if let last = lastLocation,
               location.distance(from: last) < 3 {
                return
            }
            lastLocation = location
            parent.pathCoordinates.append(location.coordinate)
            
            let latLng = NMGLatLng(
                lat: location.coordinate.latitude,
                lng: location.coordinate.longitude
            )
            
            if !didMoveInitialCamera {
                let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
                cameraUpdate.animation = .easeIn
                mapView.moveCamera(cameraUpdate)
                didMoveInitialCamera = true
                return
            }
            
            if parent.shouldCenterOnUser {
                let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
                cameraUpdate.animation = .easeIn
                mapView.moveCamera(cameraUpdate)
            }
        }
        
        func updatePath(_ coordinates: [CLLocationCoordinate2D]) {
            guard let mapView = mapView,
                  coordinates.count > 1 else { return }
            
            pathOverlay?.mapView = nil
            
            let latLngs = coordinates.map {
                NMGLatLng(lat: $0.latitude, lng: $0.longitude)
            }
            
            let path = NMFPath(points: latLngs)
            path?.width = 6
            path?.color = .defaultPrimary
            path?.outlineWidth = 0
            path?.mapView = mapView
            
            self.pathOverlay = path
        }
    }
}
