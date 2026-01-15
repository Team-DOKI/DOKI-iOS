//
//  RegisterView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            currentStepView
            
            Spacer()
            
            mainButton
        }
        .overlay(alignment: .top) { progressBar }
        .overlay(alignment: .top, content: {
            if viewModel.isShowMapView {
                AreaMapView(viewModel: viewModel)
            }
        })
        .topNavigationView {
            BackButton {
                if viewModel.isFirstStep {
                    dismiss()
                } else {
                    viewModel.goToPrevStep()
                }
            }
        } center: {
            Text(viewModel.currentStep.navTitle)
                .subtitle()
        }
    }
}

extension RegisterView {
    private var currentStepView: some View {
        Group {
            switch viewModel.currentStep {
            case .userProfile:
                UserInfoView(viewModel: viewModel)
            case .dogProfile:
                DogInfoView(viewModel: viewModel)
            case .activityArea:
                ActivityAreaView(viewModel: viewModel)
            }
        }
    }
    
    private var progressBar: some View {
        ProgressView(value: 1.0/3 * Double(viewModel.currentStep.rawValue + 1))
            .frame(height: 2)
            .progressViewStyle(.linear)
            .tint(.defaultPrimary)
            .animation(.easeInOut, value: viewModel.currentStep)
    }
    
    private var mainButton: some View {
        MainButton(text: viewModel.isLastStep ? "완료" : "다음", buttonState: viewModel.buttonDisabled ? .disabled : .active1) {
            if viewModel.isLastStep {
                // TODO: API 연동 전까지 임시 코드
                authManager.authStatus = .loggedIn
            } else {
                viewModel.goToNextStep()
            }
        }
        .padding(.horizontal, 16)
    }
}

