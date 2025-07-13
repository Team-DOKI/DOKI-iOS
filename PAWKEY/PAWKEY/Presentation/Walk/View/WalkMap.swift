//
//  WalkMap.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import MapKit

struct WalkMap: UIViewRepresentable {
    // 현재 맵의 보여줄 영역 (중심 좌표와 span)
    @Binding var region: MKCoordinateRegion
    
    // 그려질 경로의 좌표 배열
    @Binding var pathCoordinates: [CLLocationCoordinate2D]
    
    // 사용자 위치로 지도를 이동
    @Binding var shouldCenterOnUser: Bool
    
    // 스냅샷
    @Binding var snapshotImage: UIImage?
    
    
    // MKMapView 초기 설정
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    // 상태값이 바뀌면 여기서 MKMapView를 갱신
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if shouldCenterOnUser {
            uiView.setRegion(region, animated: true)
            DispatchQueue.main.async {
                shouldCenterOnUser = false
            }
        }
        
        // 경로 그리기 갱신
        context.coordinator.updatePolyline(on: uiView, with: pathCoordinates)
    }
    
    // Coordinator: MKMapViewDelegate 연결용
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func updatePolyline(on mapView: MKMapView, with coordinates: [CLLocationCoordinate2D]) {
            mapView.overlays.forEach { mapView.removeOverlay($0) }
            guard coordinates.count > 1 else { return }
            
            // 새로운 polyline 생성 후 지도에 추가
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
            // 사용자 위치 아이콘 커스텀 뷰 반환
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
