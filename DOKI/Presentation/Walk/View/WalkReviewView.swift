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
                
                walkInfoSection
                
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
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .overlay(alignment: .top, content: {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.defaultButton)
        })
        .topNavigationView(center: {
            Text("산책 기록하기")
                .subtitle()
        })
        .customAlert(
            isPresented: $viewModel.isShowReviewCompleted,
            image: Image(.imgFoot),
            message: "후기가 등록이 완료되었어요!",
            subMessage: "덕분에 DOKI가 보호자님을 더 잘 알게 됐어요.\n이 정보로 다음엔 더 완벽한 경로를 추천해 드릴게요.",
            secondaryTitle: "홈으로 돌아가기",
            primaryTitle: "자세히 보러가기",
            secondaryAction: viewModel.navigateBackToRoot,
            primaryAction: viewModel.navigateToDetail
        )
        .ignoresSafeArea(.container, edges: .bottom)
        .task {
            viewModel.fetchWalkSummary()
            await viewModel.fetchFilterCategories()
            viewModel.bindData()
        }
    }
}

extension WalkReviewView {
    private var walkInfoSection: some View {
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
        let remainingSlots = max(0, 3 - viewModel.walkImages.count)

        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if remainingSlots > 0 {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: remainingSlots,
                        matching: .images
                    ) {
                        Rectangle()
                            .frame(width: 160, height: 160)
                            .foregroundStyle(.defaultButton)
                            .cornerRadius(8)
                            .overlay(Image(.btnAddimg))
                    }
                    .onChange(of: selectedItems) { _, selectedPhoto in
                        handleSelectedPhotos(selectedPhoto)
                    }
                }

                ForEach(Array(viewModel.walkImages.enumerated()), id: \.offset) { index, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .cornerRadius(8)
                        .clipped()
                        .overlay(alignment: .topTrailing) {
                            Button {
                                viewModel.removeWalkImage(at: index)
                            } label: {
                                Image(.btnReviewdelete)
                                    .padding(6)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                }
            }
        }
    }
    
    private var congestionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: "혼잡도",
                subtitle: "(필수 선택)"
            )

            SegmentedButton(
                items: viewModel.congestion,
                selectedItem: $viewModel.selectedCongestion
            )
        }
    }

    // 강아지 교류 빈도
    private var dogInteractionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: "강아지 교류 빈도",
                subtitle: "(필수 선택)"
            )

            SegmentedButton(
                items: viewModel.exchange,
                selectedItem: $viewModel.selectedExchange
            )
        }
    }
    
    // 안전
    private var safetySection: some View {
        SelectableSection(
            title: "안전",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.safety
        )
    }
    
    // 편의성
    private var convenienceSection: some View {
        SelectableSection(
            title: "편의성",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.convenience
        )
    }
    
    // 환경
    private var environmentSection: some View {
        SelectableSection(
            title: "환경",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.environment
        )
    }
    private var reviewSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "산책에 대한 후기를 작성해주세요")
            
            Spacer().frame(height: 16)
            
            TextField("후기 제목을 입력해주세요", text: $viewModel.title)
                .font(.bodyDefault)
                .padding(17)
                .background(.defaultBright)
                .cornerRadius(8)
            
            Spacer().frame(height: 8)
            
            TextArea(placeholder: "산책에 대한 내용을 작성해주세요", text: $viewModel.description)
        }
    }
    
    private var buttonSection: some View {
        let isLoading = viewModel.loadingStatus == .loading
        return VStack(spacing: 16) {
            MainButton(
                text: "산책 기록 나만보기",
                buttonState: (isLoading && viewModel.tappedButton == false) ? .loading(base: .active2) : (viewModel.isFormValid && !isLoading ? .active2 : .disabled),
                action: { viewModel.uploadPost(isPublic: false) }
            )

            MainButton(
                text: "산책 기록 공유하기",
                buttonState: (isLoading && viewModel.tappedButton == true) ? .loading(base: .active1) : (viewModel.isFormValid && !isLoading ? .active1 : .disabled),
                action: { viewModel.uploadPost(isPublic: true) }
            )
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
                       !viewModel.walkImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                        viewModel.uploadWalkImage(newImage)
                    }
                case .failure:
                    break
                }
            }
        }
        selectedItems.removeAll()
    }
}
