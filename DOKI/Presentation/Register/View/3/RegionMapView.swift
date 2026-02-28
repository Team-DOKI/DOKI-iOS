//
//  RegionMapView.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct RegionMapView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        Image(.mapView)
            .resizable()
            .overlay(alignment: .bottom) {
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
    }
}
