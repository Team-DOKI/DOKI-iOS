//
//  ActivityAreaView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct ActivityAreaView: View {
    @ObservedObject var viewModel: ProfileSetUpViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                
                Spacer().frame(height: 20)
                
                Text("활동 범위가 어떻게 되시나요?")
                    .font(.head_22_sb)
                    .foregroundStyle(.pawkeyBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 42)
                
                VStack(alignment: .leading) {
                    Text("지역구")
                        .font(.body_14_sb)
                    FlexibleGrid(availableWidth: proxy.size.width - 32,
                                     data: viewModel.regionList,
                                     spacing: 14,
                                     alignment: .leading, content: {
                        LocationButton($0, type: .small, isSelected: $0 == viewModel.userProfile.region) { region in
                            viewModel.changeUserInfo(.region(region))
                        }
                    })
                    .clipped()
                }
                
                Spacer().frame(height: 42)
                
                if !viewModel.userProfile.region.isEmpty {
                    VStack(alignment: .leading) {
                        Text("법정동")
                            .font(.body_14_sb)
                        FlexibleGrid(availableWidth: proxy.size.width - 32,
                                         data: viewModel.legalRegionList,
                                         spacing: 14,
                                         alignment: .leading, content: {
                            LocationButton($0, type: .small, isSelected: $0 == viewModel.userProfile.legalRegion) { legalRegion in
                                viewModel.changeUserInfo(.legalRegion(legalRegion))
                            }
                        })
                        .padding(.trailing, 72)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}
