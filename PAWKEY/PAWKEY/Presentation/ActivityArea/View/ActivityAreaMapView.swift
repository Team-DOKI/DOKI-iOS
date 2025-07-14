//
//  ActivityAreaMapView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI
import MapKit

struct ActivityAreaMapView: View {
    @EnvironmentObject var coordinator: Coordinator<HomeScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject var viewModel: ActivityAreaMapViewModel
    
    init(viewModel: ActivityAreaMapViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PolygonMapView(region: viewModel.region, polygons: viewModel.activityAreas.map { $0.coordinates })
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.isShowToast {
                ToastMessage(message: "지역을 강남구 \(viewModel.regionName)으로 변경했어요.")
                    .transition(.opacity)
                    .padding(.bottom, 246 + 22)
            }
            
            VStack(alignment: .leading, spacing: 0) {
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
                                Text(viewModel.regionName)
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
                                Task {
                                    await viewModel.updateUserRegion(regionId: 40)
                                    
                                    withAnimation {
                                        viewModel.isShowToast = false
                                        mainTabViewModel.isHidden = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            mainTabViewModel.isHidden = false
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            mainTabViewModel.isHidden = false
                                            coordinator.popToRoot()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 32)
                            .padding(.bottom, 30)
                        }
                            .overlay(alignment: .bottom, content: {
                                Rectangle()
                                    .foregroundStyle(.white)
                                    .frame(height: 100)
                                    .offset(y: 95)
                            })
                    )
            }
        }
        .topNavigationView(left: {
            BackButton {
                coordinator.pop()
            }
        }, center: {
            Text("내 동네 설정")
                .font(.body_16_sb)
        })
        .onAppear {
            Task {
                await viewModel.fetchActivityArea(regionId: 40)
            }
        }
    }
    
    struct PolygonMapView: UIViewRepresentable {
        var region: MKCoordinateRegion
        var polygons: [[[CLLocationCoordinate2D]]]
        
        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = context.coordinator
            mapView.setRegion(region, animated: false)
            return mapView
        }
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.setRegion(region, animated: true)
            uiView.removeOverlays(uiView.overlays)
            
            for rings in polygons {
                for coords in rings {
                    let polygon = MKPolygon(coordinates: coords, count: coords.count)
                    uiView.addOverlay(polygon)
                }
            }
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
}
