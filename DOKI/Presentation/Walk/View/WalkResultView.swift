//
//  WalkResultView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI
import PhotosUI

struct WalkResultView: View {
    @StateObject var viewModel: WalkResultViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 16)
                photoPicker
                
                Spacer().frame(height: 40)
                congestionSection
                Spacer().frame(height: 40)
                dogInteractionSection
                Spacer().frame(height: 40)
                safetySection
                Spacer().frame(height: 40)
                convenienceSection
                Spacer().frame(height: 40)
                environmentSection
                Spacer().frame(height: 40)
                reviewSection
            }
            .padding(.horizontal, 16)
        }
        .topNavigationView {
            BackButton(action: {})
        } center: {
            Text("산책 기록하기")
                .subtitle()
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

extension WalkResultView {
    private var photoPicker: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 3,
            matching: .images
        ) {
            if viewModel.reviewImages.isEmpty {
                Rectangle()
                .frame(width: 160, height: 160)
                .foregroundStyle(.defaultButton)
                .cornerRadius(8)
                .overlay(Image(.icAddImg))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.reviewImages, id: \.self) {
                            Image(uiImage: $0)
                                .resizable()
                                .frame(width: 160, height: 160)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedItems) { _, selectedPhoto in
            handleSelectedPhotos(selectedPhoto)
        }
    }
    
    private var congestionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: "혼잡도",
                subtitle: "(단일 선택 가능)"
            )
            
            SegmentedButton(
                items: viewModel.congestionOption,
                selectedItem: $viewModel.selectedCongestion
            )
        }
    }
    
    // 강아지 교류 빈도
    private var dogInteractionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: "강아지 교류 빈도",
                subtitle: "(단일 선택 가능)"
            )
            
            SegmentedButton(
                items: viewModel.dogInteractionOption,
                selectedItem: $viewModel.selectedDogInteraction
            )
        }
    }
    
    // 안전
    private var safetySection: some View {
        SelectableSection(
            title: "안전",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.safetyOption
        )
    }
    
    // 편의성
    private var convenienceSection: some View {
        SelectableSection(
            title: "편의성",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.convenienceOption
        )
    }
    
    // 환경
    private var environmentSection: some View {
        SelectableSection(
            title: "환경",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.environmentOption
        )
    }
    private var reviewSection: some View {
        VStack {}
    }
}

extension WalkResultView {
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data,
                       let newImage = UIImage(data: data),
                       !viewModel.reviewImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                        DispatchQueue.main.async {
                            viewModel.reviewImages.append(newImage)
                        }
                    }
                case .failure:
                    break
                }
            }
        }
        selectedItems.removeAll()
    }
}
