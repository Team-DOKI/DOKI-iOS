//
//  WalkNaverMapView.swift
//  DOKI
//
//  Created by 이세민 on 1/9/26.
//

import SwiftUI
import NMapsMap
import CoreLocation
import Combine

struct WalkNaverMapView: UIViewRepresentable {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    @Binding var pathCoordinates: [CLLocationCoordinate2D]
    @Binding var userTrackingMode: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        mapView.positionMode = .direction
        
        let overlay = mapView.locationOverlay
        overlay.hidden = false
        
        context.coordinator.mapView = mapView
        return mapView
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
    }
    
    class Coordinator: NSObject {
        let parent: WalkNaverMapView
        weak var mapView: NMFMapView?
        
        private var pathOverlay: NMFPath?
        private var lastLocation: CLLocation?
        private var didMoveInitialCamera = false
        private var cancellables = Set<AnyCancellable>()
        
        init(_ parent: WalkNaverMapView) {
            self.parent = parent
            super.init()
            
            parent.locationManager.$currentLocation
                .compactMap { $0 }
                .sink { [weak self] location in
                    self?.update(location)
                }
                .store(in: &cancellables)
        }
        
        private func update(_ location: CLLocation) {
            guard let mapView = mapView else { return }
            
            let latLng = NMGLatLng(
                lat: location.coordinate.latitude,
                lng: location.coordinate.longitude
            )
            
            let overlay = mapView.locationOverlay
            overlay.location = latLng
            overlay.hidden = false
            
            if let image = UIImage(named: "ic_mylocation") {
                overlay.icon = NMFOverlayImage(image: image)
            }
            
            if !didMoveInitialCamera || parent.userTrackingMode {
                let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
                cameraUpdate.animation = .easeIn
                mapView.moveCamera(cameraUpdate)
                didMoveInitialCamera = true
            }
            
            if let last = lastLocation,
               location.distance(from: last) < 3 { return }
            
            lastLocation = location
            parent.pathCoordinates.append(location.coordinate)
            updatePath()
        }
        
        private func updatePath() {
            guard let mapView = mapView,
                  parent.pathCoordinates.count > 1 else { return }
            
            pathOverlay?.mapView = nil
            
            let latLngs = parent.pathCoordinates.map {
                NMGLatLng(lat: $0.latitude, lng: $0.longitude)
            }
            
            let path = NMFPath(points: latLngs)
            path?.width = 6
            path?.color = .defaultPrimary
            path?.outlineWidth = 0
            path?.mapView = mapView
            
            pathOverlay = path
        }
    }
}
