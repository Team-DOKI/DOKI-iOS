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
    @ObservedObject var viewModel: WalkRecordViewModel
    
    @Binding var pathCoordinates: [CLLocationCoordinate2D]
    @Binding var userTrackingMode: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()

        if let location = locationManager.currentLocation {
            let latLng = NMGLatLng(
                lat: location.coordinate.latitude,
                lng: location.coordinate.longitude
            )

            let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
            cameraUpdate.animation = .none
            mapView.moveCamera(cameraUpdate)
        }

        mapView.positionMode = .normal

        let overlay = mapView.locationOverlay
        overlay.hidden = false

        if let image = UIImage(named: "ic_mylocation") {
            overlay.icon = NMFOverlayImage(image: image)
        }

        mapView.addCameraDelegate(delegate: context.coordinator)
        context.coordinator.mapView = mapView

        viewModel.captureMapAction = { [weak coordinator = context.coordinator] completion in
            coordinator?.captureSnapshotAsync(completion: completion)
        }

        return mapView
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        guard userTrackingMode else { return }
        guard let location = locationManager.currentLocation else { return }
        
        let target = NMGLatLng(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: target)
        cameraUpdate.animation = .easeIn
        uiView.moveCamera(cameraUpdate)
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        let parent: WalkNaverMapView
        weak var mapView: NMFMapView?

        private var pathOverlay: NMFPath?
        private var lastLocation: CLLocation?
        private var cancellables = Set<AnyCancellable>()

        func captureSnapshotAsync(completion: @escaping (UIImage?) -> Void) {
            guard let mapView = mapView, !mapView.bounds.isEmpty else {
                completion(nil)
                return
            }

            // 전체 경로가 보이도록 카메라 이동
            let coordinates = parent.pathCoordinates
            if coordinates.count > 1 {
                var minLat = coordinates[0].latitude, maxLat = coordinates[0].latitude
                var minLng = coordinates[0].longitude, maxLng = coordinates[0].longitude
                for coord in coordinates {
                    minLat = min(minLat, coord.latitude)
                    maxLat = max(maxLat, coord.latitude)
                    minLng = min(minLng, coord.longitude)
                    maxLng = max(maxLng, coord.longitude)
                }
                let sw = NMGLatLng(lat: minLat, lng: minLng)
                let ne = NMGLatLng(lat: maxLat, lng: maxLng)
                let bounds = NMGLatLngBounds(southWest: sw, northEast: ne)
                let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 60)
                cameraUpdate.animation = .none
                mapView.moveCamera(cameraUpdate)
            }

            // Metal이 re-render할 시간을 준 뒤 캡처
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak mapView] in
                guard let mapView = mapView, !mapView.bounds.isEmpty else {
                    completion(nil)
                    return
                }
                let renderer = UIGraphicsImageRenderer(size: mapView.bounds.size)
                let image = renderer.image { _ in
                    mapView.drawHierarchy(in: mapView.bounds, afterScreenUpdates: true)
                }
                completion(image)
            }
        }
        
        init(_ parent: WalkNaverMapView) {
            self.parent = parent
            super.init()
            
            parent.locationManager.$currentLocation
                .compactMap { $0 }
                .sink { [weak self] location in
                    DispatchQueue.main.async {
                        self?.update(location)
                    }
                }
                .store(in: &cancellables)
        }
        
        func mapView(_ mapView: NMFMapView,
                     cameraDidChangeByReason reason: Int,
                     animated: Bool) {
            
            guard reason == NMFMapChangedByGesture else { return }
            
            guard parent.userTrackingMode else { return }
            
            guard let location = parent.locationManager.currentLocation else { return }
            
            let target = NMGLatLng(
                lat: location.coordinate.latitude,
                lng: location.coordinate.longitude
            )
            
            let current = mapView.cameraPosition.target
            let distance = current.distance(to: target)
            
            guard distance > 3 else { return }
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: target)
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        }
        
        private func update(_ location: CLLocation) {
            if let last = lastLocation,
               location.distance(from: last) < 3 { return }
            
            lastLocation = location
            parent.viewModel.updateLocation(location)
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
