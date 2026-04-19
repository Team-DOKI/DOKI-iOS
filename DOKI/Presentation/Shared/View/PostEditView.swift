//
//  PostEditView.swift
//  DOKI
//

import SwiftUI
import PhotosUI
import Kingfisher

struct PostEditView: View {
    @StateObject var viewModel: PostEditViewModel
    let onSuccess: () -> Void

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
        .overlay(alignment: .top) {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.defaultButton)
        }
        .topNavigationView(center: {
            Text("산책 기록 수정하기")
                .subtitle()
        })
        .ignoresSafeArea(.container, edges: .bottom)
        .task {
            await viewModel.fetchFilterCategories()
        }
    }
}

extension PostEditView {
    private var photoPicker: some View {
        let remainingSlots = max(0, 3 - viewModel.totalImageCount)

        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // 3장 미만이면 추가 버튼 (왼쪽 고정)
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

                // 기존 이미지 (X 버튼 포함)
                ForEach(Array(viewModel.existingImageURLs.enumerated()), id: \.offset) { index, url in
                    imageCell {
                        KFImage(URL(string: url))
                            .resizable()
                            .scaledToFill()
                    } onDelete: {
                        viewModel.removeExistingImage(at: index)
                    }
                }

                // 새로 추가한 이미지 (X 버튼 포함)
                ForEach(Array(viewModel.newWalkImages.enumerated()), id: \.offset) { index, image in
                    imageCell {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } onDelete: {
                        viewModel.removeNewImage(at: index)
                    }
                }
            }
        }
    }

    private func imageCell<Content: View>(
        @ViewBuilder content: () -> Content,
        onDelete: @escaping () -> Void
    ) -> some View {
        content()
            .frame(width: 160, height: 160)
            .cornerRadius(8)
            .clipped()
            .overlay(alignment: .topTrailing) {
                Button(action: onDelete) {
                    Image(.btnReviewdelete)
                        .padding(6)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
    }

    private var walkInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title: { Text(viewModel.address) }, icon: { Image(.icMarker) })
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)

            Label(title: { Text(viewModel.recordDate) }, icon: { Image(.icTimeclock) })
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)

            Label(title: { Text(viewModel.walkRecord) }, icon: { Image(.icWalkinfo) })
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
        }
    }

    private var congestionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "혼잡도", subtitle: "(필수 선택)")
            SegmentedButton(
                items: viewModel.congestion,
                selectedItem: $viewModel.selectedCongestion
            )
        }
    }

    private var dogInteractionSection: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "강아지 교류 빈도", subtitle: "(필수 선택)")
            SegmentedButton(
                items: viewModel.exchange,
                selectedItem: $viewModel.selectedExchange
            )
        }
    }

    private var safetySection: some View {
        SelectableSection(
            title: "안전",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.safety
        )
    }

    private var convenienceSection: some View {
        SelectableSection(
            title: "편의성",
            subtitle: "(복수 선택 가능)",
            items: $viewModel.convenience
        )
    }

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
                action: { viewModel.updatePost(isPublic: false, onSuccess: onSuccess) }
            )

            MainButton(
                text: "산책 기록 공유하기",
                buttonState: (isLoading && viewModel.tappedButton == true) ? .loading(base: .active1) : (viewModel.isFormValid && !isLoading ? .active1 : .disabled),
                action: { viewModel.updatePost(isPublic: true, onSuccess: onSuccess) }
            )
        }
    }
}

extension PostEditView {
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data,
                       let newImage = UIImage(data: data),
                       !viewModel.newWalkImages.contains(where: { $0.pngData() == newImage.pngData() }) {
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
