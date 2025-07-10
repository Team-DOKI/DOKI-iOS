//
//  ActivityAreaMapView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI
import MapKit

struct ActivityArea: Identifiable {
    let id = UUID()
    let coordinates: [CLLocationCoordinate2D]
}

struct ActivityAreaMapView: View {
    @EnvironmentObject var router: TabRouter<HomeScreen>
    @EnvironmentObject var tabBarState: TabBarState
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5215, longitude: 127.0250),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var activityAreas: [ActivityArea] = []
    @State private var showToast = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PolygonMapView(region: region, polygons: activityAreas.map { $0.coordinates })
                .edgesIgnoringSafeArea(.all)
            
            if showToast {
                ToastMessage(message: "지역을 강남구 역삼동으로 변경했어요.")
                    .transition(.opacity)
                    .padding(.bottom, 246 + 22)
            }
            
            VStack(alignment: .leading) {
                Color.pawkeyWhite1
                    .frame(height: 246)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .overlay(
                        VStack(alignment: .leading) {
                            HStack {
                                Text("선택한 위치")
                                    .font(.head_20_b)
                                    .foregroundColor(.pawkeyBlack)
                                Spacer()
                                Text("신사동")
                                    .font(.head_20_b)
                                    .foregroundColor(.green500)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 32)
                            .padding(.bottom, 18)
                            
                            Text("기존에 산책하던 지역은 0000이에요.\n선택한 위치로 산책 지역을 변경하시겠어요?")
                                .font(.body_14_m)
                                .foregroundColor(.gray500)
                                .padding(.top, 12)
                                .padding(.horizontal, 16)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            CTAButton(title: "지역 변경하기") {
                                withAnimation {
                                    showToast = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 32)
                            .padding(.bottom, 30)
                        }
                    )
            }
        }
        .topNavigationView(left: {
            BackButton {
                router.pop()
            }
        }, center: {
            Text("내 동네 설정")
                .font(.body_16_sb)
        })
        .onAppear {
            loadActivityAreas()
        }
    }
    
    // 임시 신사동 좌표
    func loadActivityAreas() {
        let polygonCoordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.5259, longitude: 127.0276),
            CLLocationCoordinate2D(latitude: 37.5225, longitude: 127.0287),
            CLLocationCoordinate2D(latitude: 37.5195, longitude: 127.0294),
            CLLocationCoordinate2D(latitude: 37.5179, longitude: 127.0262),
            CLLocationCoordinate2D(latitude: 37.5190, longitude: 127.0225),
            CLLocationCoordinate2D(latitude: 37.5215, longitude: 127.0213),
            CLLocationCoordinate2D(latitude: 37.5240, longitude: 127.0238),
            CLLocationCoordinate2D(latitude: 37.5259, longitude: 127.0276)
        ]
        
        let area = ActivityArea(coordinates: polygonCoordinates)
        self.activityAreas = [area]
    }
}

struct PolygonMapView: UIViewRepresentable {
    var region: MKCoordinateRegion
    var polygons: [[CLLocationCoordinate2D]]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        
        for coords in polygons {
            let polygon = MKPolygon(coordinates: coords, count: coords.count)
            uiView.addOverlay(polygon)
        }
        
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.green500.withAlphaComponent(0.3)
                renderer.strokeColor = UIColor.green500
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
