//
//  ProfileSetUpView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import Combine

struct ProfileSetUpView: View, KeyboardReadable {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject var viewModel: ProfileSetUpViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    ProgressBarView(
                        width: proxy.size.width,
                        step: viewModel.currentStepIndex
                    )
                    Spacer()
                    
                    // 서브뷰
                    Group {
                        switch viewModel.currentStep {
                        case .ownerInfo:
                            UserInfoView(viewModel: viewModel)
                        case .activityArea:
                            ActivityAreaView(viewModel: viewModel)
                        case .dogInfo:
                            DogInfoView(viewModel: viewModel)
                        case .dogTendency:
                            DogTendencyView(viewModel: viewModel)
                        }
                    }
                    
                    if !viewModel.isKeyboardVisible {
                        CTAButton(
                            title: viewModel.currentStep == .dogTendency ? "등록하기" : "다음으로",
                            isDisabled: viewModel.isButtonDisabled
                        ) {
                            if viewModel.currentStep == .dogTendency {
                                Task {
                                    await viewModel.updateUserProfile()
                                }
                            } else {
                                viewModel.goToNextStep()
                            }
                        }
                        .padding(.bottom, 29)
                        .padding(.horizontal, 16)
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: viewModel.isKeyboardVisible ? 20 : 0)
                }
                .topNavigationView(left: {
                    VStack {
                        if viewModel.currentStepIndex > 1 {
                            BackButton {
                                viewModel.goToPrevStep()
                            }
                        }
                    }
                }, center: {
                    Text(viewModel.currentStep.title)
                        .font(.body_16_sb)
                })
                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                    viewModel.isKeyboardVisible = newIsKeyboardVisible
                }
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }                
            }
        }
    }
}

struct ProgressBarView: View {
    let width: CGFloat
    let step: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.gray100)
            
            Rectangle()
                .frame(width: width * CGFloat(step) / 4, height: 2)
                .foregroundStyle(.green500)
        }
        .animation(.easeInOut, value: step)
    }
}


