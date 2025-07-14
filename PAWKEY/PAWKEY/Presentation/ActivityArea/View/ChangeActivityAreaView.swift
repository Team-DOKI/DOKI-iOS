//
//  ChangeActivityAreaView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct ChangeActivityAreaView: View {
    @StateObject var viewModel: ChangeActivityAreaViewModel
    
    @EnvironmentObject var router: Coordinator<HomeScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    init(viewModel: ChangeActivityAreaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
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
                .padding(.top, 28)
                
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
                
                CTAButton(
                    title: "다음으로",
                    isDisabled: viewModel.userProfile.region.isEmpty || viewModel.userProfile.legalRegion.isEmpty
                ) {
                    router.push(.acvitiyAreaMap)                    
                }
                .padding(.bottom, 29)
            }
            .padding(.horizontal, 16)
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
            withAnimation {
                mainTabViewModel.isHidden = true
            }
        }
    }
}
