//
//  RegionMapView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct RegionMapView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        ZStack {
            RegionNaverMapView(viewModel: viewModel)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("선택한 위치").header3()
                        
                        Spacer()
                        
                        Text(viewModel.previewRegionName)
                            .header3(color: .defaultPrimary)
                    }
                    .padding(.bottom, 8)
                    
                    Text(
                        "선택한 산책 지역은 \(viewModel.previewRegionName)이에요.\n이 위치로 산책 지역을 설정하시겠어요?"
                    )
                    .bodyDefault(color: .defaultMiddle)
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 8) {
                        MainButton(
                            text: "위치 수정하기",
                            buttonState: .active2,
                            font: .subtitle
                        ) {
                            viewModel.resetRegionSelection()
                            viewModel.regionFlow = .search
                        }
                        
                        MainButton(text: "선택하기", font: .subtitle) {
                            viewModel.selectRegion()
                            viewModel.regionFlow = .none
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 40)
                .padding(.bottom, 30)
                .background(.defaultBackground)
                .cornerRadius(16, corners: [.topLeft, .topRight])
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct RegionNaverMapView: UIViewRepresentable {
    @ObservedObject var viewModel: RegisterViewModel
    
    class Coordinator {
        var polygonOverlay: NMFPolygonOverlay?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.mapType = .basic
        mapView.zoomLevel = 14
        return mapView
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        if let existingPolygon = context.coordinator.polygonOverlay {
            existingPolygon.mapView = nil
            context.coordinator.polygonOverlay = nil
        }
        
        guard
            let geometry = viewModel.regionGeometry,
            geometry.type == "MultiPolygon"
        else { return }
        
        let multiPolygon = geometry.coordinates
        guard !multiPolygon.isEmpty else { return }
        
        let firstPolygonCoordinates = multiPolygon[0][0]
        
        var latLngs: [NMGLatLng] = firstPolygonCoordinates.map { coord in
            NMGLatLng(lat: coord[1], lng: coord[0])
        }
        
        if let first = latLngs.first, let last = latLngs.last,
           first.lat != last.lat || first.lng != last.lng {
            latLngs.append(first)
        }
        
        let polygonOverlay = NMFPolygonOverlay(latLngs)
        polygonOverlay?.fillColor = UIColor.green.withAlphaComponent(0.3)
        polygonOverlay?.outlineColor = UIColor.green
        polygonOverlay?.outlineWidth = 2
        polygonOverlay?.mapView = uiView
        
        context.coordinator.polygonOverlay = polygonOverlay
        
        if let firstPoint = latLngs.first {
            let cameraUpdate = NMFCameraUpdate(scrollTo: firstPoint)
            uiView.moveCamera(cameraUpdate)
        }
    }
}
