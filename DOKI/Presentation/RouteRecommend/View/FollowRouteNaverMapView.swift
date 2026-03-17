//
//  FollowRouteNaverMapView.swift
//  DOKI
//
//  Created by 이세민 on 3/12/26.
//

import SwiftUI
import NMapsMap
import CoreLocation

// TODO: - 점검 필요
struct FollowRouteNaverMapView: UIViewRepresentable {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    var pathCoordinates: [CLLocationCoordinate2D]
    @Binding var userTrackingMode: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        
        mapView.positionMode = .direction
        
        context.coordinator.mapView = mapView
        
        return mapView
    }
    
    func updateUIView(_ mapView: NMFMapView, context: Context) {
        context.coordinator.drawPath(pathCoordinates)
    }
    
    class Coordinator: NSObject {
        let parent: FollowRouteNaverMapView
        weak var mapView: NMFMapView?
        
        private var pathOverlay: NMFPath?
        
        init(_ parent: FollowRouteNaverMapView) {
            self.parent = parent
        }
        
        func drawPath(_ coordinates: [CLLocationCoordinate2D]) {
            
            guard let mapView = mapView else { return }
            guard coordinates.count > 1 else { return }
            
            pathOverlay?.mapView = nil
            
            let latLngs = coordinates.map {
                NMGLatLng(lat: $0.latitude, lng: $0.longitude)
            }
            
            let path = NMFPath(points: latLngs)
            path?.width = 6
            path?.color = .defaultPrimary
            path?.outlineWidth = 0
            path?.mapView = mapView
            
            pathOverlay = path
            
            moveCameraToRoute(latLngs)
        }
        
        private func moveCameraToRoute(_ latLngs: [NMGLatLng]) {
            
            guard let mapView = mapView else { return }
            
            let bounds = NMGLatLngBounds(latLngs: latLngs)
            
            let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 40)
            
            mapView.moveCamera(cameraUpdate)
        }
    }
}
