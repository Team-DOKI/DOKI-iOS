//
//  WalkingMapView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import MapKit

struct WalkingMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var pathCoordinates: [CLLocationCoordinate2D]
    @Binding var shouldCenterOnUser: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if shouldCenterOnUser {
            uiView.setRegion(region, animated: true)
            DispatchQueue.main.async {
                shouldCenterOnUser = false
            }
        }

        context.coordinator.updatePolyline(on: uiView, with: pathCoordinates)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func updatePolyline(on mapView: MKMapView, with coordinates: [CLLocationCoordinate2D]) {
            mapView.overlays.forEach { mapView.removeOverlay($0) }
            guard coordinates.count > 1 else { return }

            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .green
                renderer.lineWidth = 7
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
