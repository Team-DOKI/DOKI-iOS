//
//  RegisterView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack {
            currentStepView
            Spacer()
            MainButton(text: "다음", buttonState: viewModel.buttonDisabled ? .disabled : .default) {
                viewModel.goToNextStep()
            }
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .top) { progressBar }
        .topNavigationView {
            BackButton { viewModel.goToPrevStep() }
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
                DogInfoView()
            case .activityArea:
                ActivityAreaView()
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
}

