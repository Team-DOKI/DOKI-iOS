//
//  SharedWalkMap.swift
//  PAWKEY
//
//  Created by 이세민 on 7/13/25.
//

import SwiftUI
import MapKit

struct SharedWalkMap: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var shouldCenterOnUser: Bool
    @Binding var userTrackingMode: MKUserTrackingMode
    var pathCoordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        
        mapView.userTrackingMode = .followWithHeading
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setUserTrackingMode(userTrackingMode, animated: true)
        
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
                renderer.strokeColor = .green500
                renderer.lineWidth = 6
                renderer.lineCap = .round
                renderer.lineJoin = .round
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                let identifier = "UserLocation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.image = UIImage(resource: .myLocation)
                    annotationView?.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
                    annotationView?.centerOffset = CGPoint(x: 0, y: 0)
                } else {
                    annotationView?.annotation = annotation
                }
                return annotationView
            }
            return nil
        }
    }
}
