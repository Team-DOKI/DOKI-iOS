//
//  WalkReviewView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import PhotosUI

struct WalkReviewView: View {
    @StateObject var viewModel: WalkReviewViewModel
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 16)
                
                photoPicker
                
                Spacer().frame(height: 12)
                
                WalkInfoSection
                
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
                
                Spacer().frame(height: 40)
                
                buttonSection
                
                Spacer().frame(height: 30)
            }
            .padding(.horizontal, 16)
        }        
        .overlay(alignment: .top, content: {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.defaultButton)
        })
        .topNavigationView {
            BackButton(action: {})
        } center: {
            Text("산책 기록하기")
                .subtitle()
        }
        .customAlert(
            isPresented: $viewModel.isShowReviewCompleted,
            image: Image(.imgFoot),
            message: "후기가 등록이 완료되었어요!",
            subMessage: "덕분에 DOKI가 보호자님을 더 잘 알게 됐어요.\n이 정보로 다음엔 더 완벽한 경로를 추천해 드릴게요.",
            primaryTitle: "홈으로 돌아가기",
            secondaryTitle: "자세히 보러가기",
            primaryAction: viewModel.navigateBackToRoot,
            secondaryAction: viewModel.navigateToDetail)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

extension WalkReviewView {
    private var WalkInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title: {Text(viewModel.address)}, icon: {Image(.icMarker)})
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
            
            Label(title: {Text(viewModel.recordDate)}, icon: {Image(.icTimeclock)})
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
            
            Label(title: {Text(viewModel.walkRecord)}, icon: {Image(.icWalkinfo)})
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
        }
    }
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
                .overlay(Image(.btnAddimg))
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
                title: "혼잡도"
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
                title: "강아지 교류 빈도"
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
        VStack(spacing: 0) {
            SectionHeader(title: "산책에 대한 후기를 작성해주세요")
            
            Spacer().frame(height: 16)
            
            TextField("후기 제목을 입력해주세요", text: $viewModel.reviewTitle)
                .font(.bodyDefault)
                .padding(17)
                .background(.defaultBright)
                .cornerRadius(8)
            
            Spacer().frame(height: 8)
            
            TextArea(placeholder: "산책에 대한 내용을 작성해주세요", text: $viewModel.reviewContent)
        }
    }
    
    private var buttonSection: some View {
        VStack(spacing: 16) {
            MainButton(text: "산책 기록 나만보기", buttonState: .active2, action: viewModel.showReviewComplete)
            
            MainButton(text: "산책 기록 공유하기", action: viewModel.showReviewComplete)
        }
    }
}

extension WalkReviewView {
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
