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
    @Binding var snapshotImage: UIImage?
    
    private let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
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
                renderer.lineWidth = 6
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

extension WalkCourseViewModel {
    func captureMapSnapshot(completion: @escaping (UIImage?) -> Void) {
        guard !pathCoordinates.isEmpty else {
            completion(nil)
            return
        }
        
        let lats = pathCoordinates.map { $0.latitude }
        let lons = pathCoordinates.map { $0.longitude }
        
        guard let minLat = lats.min(),
              let maxLat = lats.max(),
              let minLon = lons.min(),
              let maxLon = lons.max() else {
            completion(nil)
            return
        }
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        
        var latSpan = maxLat - minLat
        var lonSpan = maxLon - minLon
        
        let minSpan = 0.0005
        latSpan = max(latSpan, minSpan)
        lonSpan = max(lonSpan, minSpan)
        
        let paddingFactor = 1.3
        latSpan *= paddingFactor
        lonSpan *= paddingFactor
        
        let contentWidth = (UIScreen.main.bounds.width - 32) * UIScreen.main.scale
        let imageWidth: CGFloat = contentWidth
        let imageHeight: CGFloat = 156 * UIScreen.main.scale
        let imageAspect = imageWidth / imageHeight
        let spanAspect = lonSpan / latSpan
        
        if spanAspect > imageAspect {
            latSpan = lonSpan / imageAspect
        } else {
            lonSpan = latSpan * imageAspect
        }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
        )
        
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: imageWidth, height: imageHeight)
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(options.size, true, 0)
            snapshot.image.draw(at: .zero)
            
            if self.pathCoordinates.count > 1 {
                let context = UIGraphicsGetCurrentContext()
                context?.setStrokeColor(UIColor.green.cgColor)
                context?.setLineWidth(4.0 * UIScreen.main.scale)
                context?.setLineJoin(.round)
                context?.setLineCap(.round)
                
                let points = self.pathCoordinates.map { snapshot.point(for: $0) }
                context?.move(to: points.first!)
                for point in points.dropFirst() {
                    context?.addLine(to: point)
                }
                context?.strokePath()
            }
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(finalImage)
        }
    }
}
