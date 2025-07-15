//
//  ArchiveView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import PhotosUI

struct ArchiveView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject var viewModel: ArchiveViewModel
    
    init(viewModel: ArchiveViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(viewModel.selectedImages.enumerated()), id: \.element) { index, image in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 160)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                Button(action: {
                                    viewModel.selectedImages.remove(at: index)
                                }) {
                                    Image(.delete)
                                        .padding(4)
                                }
                            }
                        }
                        
                        if viewModel.selectedImages.count < 5 {
                            PhotosPicker(selection: $viewModel.selectedItems,
                                         maxSelectionCount: 5 - viewModel.selectedImages.count,
                                         matching: .images) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray5)
                                    .frame(width: 160, height: 160)
                                    .overlay(
                                        Image(.add)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, 16)
                .padding([.vertical, .bottom], 12)
                
                VStack(alignment: .leading) {
                    TimePlaceCell(type: .place(viewModel.location))
                        .padding(.bottom, 4)
                    
                    TimePlaceCell(type: .time(viewModel.time))
                        .padding(.bottom, 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.descriptionTags, id: \.self) { tag in
                                Chip(title: tag)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                    .padding(.top, 10)
                    
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Rectangle()
                    .fill(Color.pawkeyWhite2)
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                
                VStack(alignment: .leading) {
                    Text("\(viewModel.petName)와의 산책 어땠나요?")
                        .font(.head_18_sb)
                        .foregroundStyle(.pawkeyBlack)
                        .padding(.bottom, 3)
                    
                    Text("카테고리 별로 1개 이상의 키워드를 선택해주세요.")
                        .font(.body_14_r)
                        .foregroundStyle(.gray200)
                        .padding(.bottom, 23)
                    
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(viewModel.categories, id: \.categoryId) { category in
                            QuestionForm(
                                question: category.categoryName,
                                tags: viewModel.categoryOptionTexts(category.categoryId),
                                selectedTags: viewModel.selectedOptionsBinding(category.categoryId)
                            )
                        }
                    }
                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Rectangle()
                    .fill(Color.pawkeyWhite2)
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                
                VStack(alignment: .leading) {
                    Text("산책에 대한 감상을 들려주시겠어요?")
                        .font(.body_16_m)
                        .foregroundStyle(.pawkeyBlack)
                        .padding(.bottom, 10)
                    
                    ReviewTextField(type: .normal, text: $viewModel.titleText)
                    ReviewTextEditor(text: $viewModel.reviewText)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Rectangle()
                    .fill(Color.pawkeyWhite2)
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                
                VStack(spacing: 13) {
                    CTAButton(title: "산책 기록 공유하기", isDisabled: !viewModel.isButtonDisabled, buttonStyle: .filled) {
                        pushCourseDetail(isPrivate: false)
                    }
                    
                    CTAButton(title: "산책 기록 나만보기", isDisabled: !viewModel.isButtonDisabled, buttonStyle: .text) {
                        pushCourseDetail(isPrivate: true)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 34)
            }
        }
        .topNavigationView(center: {
            Text("산책 기록하기")
                .font(.body_16_sb)
        })
        .onAppear {
            withAnimation {
                mainTabViewModel.isHidden = true
            }
            
            Task {
                await viewModel.fetchCourseInfo(routeId: 8)
                await viewModel.fetchCourseCategories()
            }
        }
        .onChange(of: viewModel.selectedItems) {
            Task {
                await viewModel.loadImagesFromPicker()
            }
        }
    }
    
    private func pushCourseDetail(isPrivate: Bool) {
        let courseDetailVM = CourseDetailViewModel()
        var imagesToSend = viewModel.selectedImages
        
        if let snapshot = viewModel.snapshot {
            imagesToSend.insert(snapshot, at: 0)
        }
        
        courseDetailVM.images = imagesToSend
        courseDetailVM.isPrivate = isPrivate
        coordinator.push(.courseDetail(courseDetailVM))
    }
}
