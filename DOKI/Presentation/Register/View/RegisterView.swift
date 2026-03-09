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
    
    @Binding var hasCompletedRegister: Bool
    @Binding var showDBTIStart: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            currentStepView
            
            Spacer()
            
            mainButton
        }
        .overlay(alignment: .top) { progressBar }
        .overlay(alignment: .top, content: {
            if viewModel.regionFlow == .map {
                RegionMapView(
                    regionFlow: $viewModel.regionFlow,
                    previewRegionName: $viewModel.previewRegionName,
                    regionGeometry: viewModel.regionGeometry,
                    onSelectRegion: { viewModel.selectRegion() },
                    onResetSelection: { viewModel.resetRegionSelection() }
                )
            }
        })
        .ignoresSafeArea(.keyboard)
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
        .onAppear {
            print("ACCESS TOKEN: ", AuthManager.shared.accessToken ?? "nil")
            print("REFRESH TOKEN: ", AuthManager.shared.refreshToken ?? "nil")
            print("DEVICE ID: ", DeviceIDManager.shared.getDeviceId())
        }
    }
}

extension RegisterView {
    private var currentStepView: some View {
        Group {
            switch viewModel.currentStep {
            case .userProfile:
                UserInfoView(viewModel: viewModel)
            case .petProfile:
                PetInfoView(viewModel: viewModel)
            case .region:
                RegionView(viewModel: viewModel)
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
                viewModel.registerUser()
                hasCompletedRegister = true
                showDBTIStart = true
            } else {
                viewModel.goToNextStep()
            }
        }
        .padding(.horizontal, 16)
    }
}

