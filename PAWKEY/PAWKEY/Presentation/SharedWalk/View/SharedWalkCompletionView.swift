//
//  SharedWalkCompletionView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct SharedWalkCompletionView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject var viewModel: SharedWalkCompletionViewModel
    
    init(viewModel: SharedWalkCompletionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.pawkeyWhite2
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("포비와 함께한 산책 루트에요.")
                    .font(.head_18_sb)
                    .foregroundColor(.pawkeyBlack)
                    .padding(.top, 36)
                    .padding(.bottom, 16)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 10) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 43, height: 43)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("포비")
                                .font(.body_16_sb)
                            Text("2025.06.26 (금) | 오후 11:50")
                                .font(.caption_12_r)
                                .foregroundColor(.gray300)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding([.top, .bottom], 12)
                    
                    if let snapshot = viewModel.snapshot {
                        Image(uiImage: snapshot)
                            .resizable()
                            .frame(height: 218)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 16)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 218)
                            .cornerRadius(8)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 16)
                    }
                    
                    Divider().background(.gray100)
                    
                    StatBox(type: .borderless,
                            distance: viewModel.distance,
                            elapsedTime: viewModel.elapsedTime,
                            stepCount: viewModel.stepCount)
                }
                .padding(.bottom, 8)
                .background(.pawkeyWhite1)
                .cornerRadius(16)
                
                Spacer()
                
                CTAButton(
                    title: "후기 작성하기",
                    isDisabled: false,
                    buttonStyle: .filled
                ) {
                    coordinator.push(.reviewWrite)
                }
                .padding(.bottom, 26)
            }
            .padding(.horizontal, 16)
            .onAppear {
                withAnimation {
                    mainTabViewModel.isHidden = true
                }
            }
            .topNavigationView(center: {
                Text("산책 완료")
                    .font(.body_16_sb)
            })
        }
    }
}
