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
                    .font(.head_24_sb)
                    .foregroundStyle(.pawkeyBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 42)
                
                VStack(alignment: .leading) {
                    Text("지역구")
                        .font(.body_14_sb)
                    FlexibleGrid(availableWidth: proxy.size.width - 32,
                                 data: viewModel.regions.map { $0.gu },
                                 spacing: 14,
                                 alignment: .leading, content: { region in
                        LocationButton(region.name, type: .small, isSelected: region.id == viewModel.selectedRegiondId)
                            .disabled(true)
                            .onTapGesture {
                                viewModel.selecteRegion(region.id)
                            }
                    })
                    .clipped()
                }
                
                Spacer().frame(height: 42)
                if let selectedLegalRegions = viewModel.selectedLegalRegions {
                    VStack(alignment: .leading) {
                        Text("법정동")
                            .font(.body_14_sb)
                        FlexibleGrid(availableWidth: proxy.size.width - 32,
                                     data: selectedLegalRegions,
                                     spacing: 14,
                                     alignment: .leading, content: { legalRegion in
                            LocationButton(legalRegion.name, type: .small, isSelected: viewModel.userProfile.regionId == legalRegion.id)
                                .disabled(true)
                                .onTapGesture {
                                    viewModel.changeUserInfo(.region(legalRegion.id))
                                }
                        })
                        .padding(.trailing, 72)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .task {
            await viewModel.fetchRegions()
        }
    }
}
