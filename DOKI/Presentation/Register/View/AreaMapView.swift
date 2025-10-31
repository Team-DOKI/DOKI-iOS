//
//  AreaMapView.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import SwiftUI

struct AreaMapView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack {
                VStack(spacing: 0) {
                    Image(.mapView)
                        .resizable()
                }
                .overlay(alignment: .bottom) {
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("선택한 위치").header3()
                                Spacer()
                                Text(viewModel.regionDisplayName).header3(color: .defaultPrimary)
                            }
                            
                            Text("선택한 산책 지역은 \(viewModel.regionDisplayName)이에요.\n이 위치로 산책 지역을 설정하시겠어요?")
                                .bodyDefault(color: .defaultMiddle)
                            
                            MainButton(text: "선택") {
                                viewModel.selectActivityArea()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                    }
                    .background(.white)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                }            
        }
    }
}
