//
//  FollowRouteNaverMapView.swift
//  DOKI
//
//  Created by 이세민 on 3/12/26.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct FollowRouteNaverMapView: UIViewRepresentable {

    var pathCoordinates: [CLLocationCoordinate2D]

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.mapType = .basic
        mapView.zoomLevel = 14
        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView(_ mapView: NMFMapView, context: Context) {
        guard pathCoordinates.count > 1 else { return }
        let coord = context.coordinator
        guard coord.lastDrawnCount != pathCoordinates.count else { return }
        coord.lastDrawnCount = pathCoordinates.count
        coord.drawPath(pathCoordinates)
    }

    class Coordinator: NSObject {
        weak var mapView: NMFMapView?
        var lastDrawnCount: Int = 0
        private var pathOverlay: NMFPath?

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
