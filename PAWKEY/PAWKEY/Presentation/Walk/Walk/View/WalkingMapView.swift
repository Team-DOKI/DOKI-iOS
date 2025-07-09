//
//  WalkingMapView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import MapKit

struct WalkingMapView: UIViewRepresentable {
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
                renderer.strokeColor = .green
                renderer.lineWidth = 6
                renderer.lineCap = .round
                renderer.lineJoin = .round
                
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

extension WalkCourseViewModel {
    // 현재 경로를 기반으로 지도의 이미지 스냅샷 생성
    func captureMapSnapshot(completion: @escaping (UIImage?) -> Void) {
        guard !pathCoordinates.isEmpty else {
            completion(nil)
            return
        }
        
        // 경로의 위도, 경도 min/max 계산
        // 경로가 보이도록 영역 설정
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
        
        // 영역 계산 + 최소값 보장
        var latSpan = maxLat - minLat
        var lonSpan = maxLon - minLon
        
        let minSpan = 0.0005
        latSpan = max(latSpan, minSpan)
        lonSpan = max(lonSpan, minSpan)
        
        // 패딩
        let paddingFactor = 1.3
        latSpan *= paddingFactor
        lonSpan *= paddingFactor
        
        // 스냅샷 이미지 사이즈 계산
        let contentWidth = (UIScreen.main.bounds.width - 32) * UIScreen.main.scale
        let imageWidth: CGFloat = contentWidth
        let imageHeight: CGFloat = 156 * UIScreen.main.scale
        
        // 이미지 비율과 영역 비율 맞추기
        let imageAspect = imageWidth / imageHeight
        let spanAspect = lonSpan / latSpan
        
        if spanAspect > imageAspect {
            latSpan = lonSpan / imageAspect
        } else {
            lonSpan = latSpan * imageAspect
        }
        
        // 최종 영역 설정
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
        )
        
        // MKMapSnapshotter 옵션 설정
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: imageWidth, height: imageHeight)
        options.scale = UIScreen.main.scale
        
        // 스냅샷 생성 시작
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            // 스냅샷 이미지 위에 경로를 직접 그림
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
            
            // 최종 이미지 반환
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(finalImage)
        }
    }
}
