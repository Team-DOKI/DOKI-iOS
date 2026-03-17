//
//  RegionMapView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI
import NMapsMap

struct RegionMapView: View {
    @Binding var regionFlow: RegionFlow
    @Binding var previewRegionName: String
    
    var regionGeometry: Geometry?
    
    var onSelectRegion: () -> Void
    var onResetSelection: () -> Void

    var body: some View {
        ZStack {
            RegionNaverMapView(geometry: regionGeometry)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("선택한 위치").header3()
                        Spacer()
                        Text(previewRegionName).header3(color: .defaultPrimary)
                    }
                    .padding(.bottom, 8)
                    
                    Text(
                        "선택한 산책 지역은 \(previewRegionName)이에요.\n이 위치로 산책 지역을 설정하시겠어요?"
                    )
                    .bodyDefault(color: .defaultMiddle)
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 8) {
                        MainButton(
                            text: "위치 수정하기",
                            buttonState: .active2,
                            font: .subtitle
                        ) {
                            onResetSelection()
                            regionFlow = .search
                        }
                        
                        MainButton(
                            text: "선택하기",
                            font: .subtitle
                        ) {
                            onSelectRegion()
                            regionFlow = .none
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
    let geometry: Geometry?

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.mapType = .basic
        mapView.zoomLevel = 14
        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
        
        guard
            let geometry = geometry,
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

        if let firstPoint = latLngs.first {
            let cameraUpdate = NMFCameraUpdate(scrollTo: firstPoint)
            uiView.moveCamera(cameraUpdate)
        }
    }
}
