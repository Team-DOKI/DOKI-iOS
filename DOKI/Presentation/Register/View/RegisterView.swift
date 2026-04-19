//
//  RegisterView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import PhotosUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel

    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss

    @Binding var hasCompletedRegister: Bool
    @Binding var showDBTIStart: Bool

    @State private var isShowPhotoSheet = false
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 0) {
            currentStepView

            Spacer()

            mainButton
        }
        .overlay(alignment: .top) { progressBar }
        .overlay(alignment: .top) {
            if viewModel.regionFlow == .map {
                RegionMapView(
                    regionFlow: $viewModel.regionFlow,
                    previewRegionName: $viewModel.previewRegionName,
                    regionGeometry: viewModel.regionGeometry,
                    onSelectRegion: { viewModel.selectRegion() },
                    onResetSelection: { viewModel.resetRegionSelection() }
                )
            }
        }
        .overlay {
            if isShowPhotoSheet {
                photoBottomSheet
            }
        }
        .ignoresSafeArea(.keyboard)
        .topNavigationView {
            BackButton {
                if viewModel.isFirstStep {
                    authManager.logoutLocal()
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
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return }
            withAnimation { isShowPhotoSheet = false }
            handleSelectedPhoto(newItem)
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
                PetInfoView(viewModel: viewModel, showPhotoSheet: $isShowPhotoSheet)
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
        MainButton(
            text: viewModel.isLastStep ? "완료" : "다음",
            buttonState: viewModel.buttonDisabled ? .disabled : (viewModel.isRegistering ? .loading(base: .active1) : .active1)
        ) {
            if viewModel.isLastStep {
                viewModel.registerUser()
            } else {
                viewModel.goToNextStep()
            }
        }
        .padding(.horizontal, 16)
        .onChange(of: viewModel.registerCompleted) { completed in
            guard completed else { return }
            hasCompletedRegister = true
            showDBTIStart = true
        }
        .alert("오류", isPresented: Binding(
            get: { viewModel.registerError != nil },
            set: { if !$0 { viewModel.registerError = nil } }
        )) {
            Button("확인", role: .cancel) { viewModel.registerError = nil }
        } message: {
            Text(viewModel.registerError ?? "")
        }
    }

    private var photoBottomSheet: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { isShowPhotoSheet = false }
                }

            VStack {
                Spacer()

                VStack(spacing: 10) {
                    VStack(spacing: 0) {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Text("갤러리")
                                .mainDefault(color: .defaultPrimary)
                                .frame(maxWidth: .infinity, minHeight: 56)
                        }

                        Divider()

                        Button {
                            withAnimation { isShowPhotoSheet = false }
                            viewModel.petProfileImage = nil
                        } label: {
                            Text("기본 이미지")
                                .mainDefault(color: .defaultPrimary)
                                .frame(maxWidth: .infinity, minHeight: 56)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)

                    Button {
                        withAnimation { isShowPhotoSheet = false }
                    } label: {
                        Text("취소")
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color.defaultPrimary)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: isShowPhotoSheet)
    }

    private func handleSelectedPhoto(_ item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                guard let data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    viewModel.presignedURL(image)
                }
            default:
                print("이미지를 불러오지 못했습니다.")
            }
        }
    }
}
