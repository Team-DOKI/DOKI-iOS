//
//  FollowRouteNaverMapView.swift
//  DOKI
//
//  Created by 이세민 on 3/12/26.
//

import SwiftUI
import NMapsMap
import CoreLocation
import Combine

struct FollowRouteNaverMapView: UIViewRepresentable {

    @ObservedObject var locationManager = LocationManager.shared
    var pathCoordinates: [CLLocationCoordinate2D]
    @Binding var userTrackingMode: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.mapType = .basic
        mapView.zoomLevel = 14
        mapView.positionMode = .normal

        let overlay = mapView.locationOverlay
        overlay.hidden = false
        if let image = UIImage(named: "ic_mylocation") {
            overlay.icon = NMFOverlayImage(image: image)
        }

        if let location = locationManager.currentLocation {
            let latLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            mapView.moveCamera(NMFCameraUpdate(scrollTo: latLng))
        }

        mapView.addCameraDelegate(delegate: context.coordinator)
        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView(_ mapView: NMFMapView, context: Context) {
        // 경로 그리기 (좌표 변경 시만)
        let coord = context.coordinator
        if pathCoordinates.count > 1 && coord.lastDrawnCount != pathCoordinates.count {
            coord.lastDrawnCount = pathCoordinates.count
            coord.drawPath(pathCoordinates)
        }

        // GPS 트래킹 모드
        if userTrackingMode, let location = locationManager.currentLocation {
            let target = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            let cameraUpdate = NMFCameraUpdate(scrollTo: target)
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        }
    }

    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        let parent: FollowRouteNaverMapView
        weak var mapView: NMFMapView?
        var lastDrawnCount: Int = 0
        private var pathOverlay: NMFPath?

        init(_ parent: FollowRouteNaverMapView) {
            self.parent = parent
            super.init()
        }

        func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
            guard reason == NMFMapChangedByGesture else { return }
            if parent.userTrackingMode {
                DispatchQueue.main.async {
                    self.parent.userTrackingMode = false
                }
            }
        }

        func drawPath(_ coordinates: [CLLocationCoordinate2D]) {
            guard let mapView else { return }
            let latLngs = coordinates.map { NMGLatLng(lat: $0.latitude, lng: $0.longitude) }
            pathOverlay?.mapView = nil
            let path = NMFPath(points: latLngs)
            path?.width = 6
            path?.color = .defaultPrimary
            path?.outlineWidth = 0
            path?.mapView = mapView
            pathOverlay = path

            DispatchQueue.main.async { [weak mapView] in
                guard let mapView else { return }
                let bounds = NMGLatLngBounds(latLngs: latLngs)
                let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 60)
                cameraUpdate.animation = .none
                mapView.moveCamera(cameraUpdate)
            }
        }
    }
}
