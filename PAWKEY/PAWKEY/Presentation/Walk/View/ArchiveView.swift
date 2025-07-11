//
//  ArchiveView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import PhotosUI

struct ArchiveView: View {
    @EnvironmentObject var router: Coordinator<WalkScreen>
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject private var viewModel = ArchiveViewModel()
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    
    @State private var titleText = ""
    @State private var reviewText = ""
    
    let snapshot: UIImage?
    
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
                    TimePlaceCell(type: .place("강남구 역삼동"))
                        .padding(.bottom, 4)
                    
                    TimePlaceCell(type: .time("2025.07.08(화) | 오후 11:28"))
                        .padding(.bottom, 12)
                    
                    Chip(title: "옵션")
                        .padding(.bottom, 12)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Rectangle()
                    .fill(Color.pawkeyWhite2)
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                
                VStack(alignment: .leading) {
                    Text("포비와의 산책 어땠나요?")
                        .font(.head_18_sb)
                        .foregroundStyle(.pawkeyBlack)
                        .padding(.bottom, 3)
                    
                    Text("카테고리 별로 1개 이상의 키워드를 선택해주세요.")
                        .font(.body_14_r)
                        .foregroundStyle(.gray200)
                        .padding(.bottom, 23)
                    
                    VStack(alignment: .leading, spacing: 32) {
                        QuestionKeywordView(
                            question: "🚸 산책 중 안전 요소는 어땠나요?",
                            keywords: [
                                "킥보드나 자전거가 거의 없어요",
                                "차량이 거의 다니지 않아요",
                                "야간 조명이 잘 되어있어요",
                                "보도와 차도가 구분되어 있어요",
                                "보도가 넓어서 산책하기 편했어요"
                            ]
                        )
                        
                        QuestionKeywordView(
                            question: "🧺 산책 중 어떤 편의 시설이 있었나요?",
                            keywords: [
                                "배변 봉투 쓰레기통이 있어요",
                                "애견 산책로가 있어요",
                                "쉴 곳이 있어요",
                                "편의점이 있어요",
                                "반려견 동반 가능한 카페가 있어요"
                            ]
                        )
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
                    
                    ReviewTextField(type: .normal, text: $titleText)
                    
                    ReviewTextEditor(text: $reviewText)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Rectangle()
                    .fill(Color.pawkeyWhite2)
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                
                VStack(spacing: 13) {
                    CTAButton(title: "산책 기록 공유하기", isDisabled: false, buttonStyle: .filled) {
                        pushCourseDetail(isPrivate: false)
                    }
                    
                    CTAButton(title: "산책 기록 나만보기", isDisabled: false, buttonStyle: .text) {
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
                tabBarState.isHidden = true
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
        
        if let snapshot = snapshot {
            imagesToSend.insert(snapshot, at: 0)
        }
        
        courseDetailVM.images = imagesToSend
        courseDetailVM.isPrivate = isPrivate
        router.push(.courseDetail(courseDetailVM))
    }
}

struct QuestionKeywordView: View {
    let question: String
    let keywords: [String]
    
    @State private var selectedKeywords: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question)
                .font(.body_16_m)
                .foregroundColor(.pawkeyBlack)
                .padding(.bottom, 12)
            
            FlexibleGrid(
                availableWidth: UIScreen.main.bounds.width - 32,
                data: keywords,
                spacing: 8,
                alignment: .leading
            ) { keyword in
                ReviewTagButton(
                    title: keyword,
                    isSelected: Binding(
                        get: { selectedKeywords.contains(keyword) },
                        set: { newValue in
                            if newValue {
                                selectedKeywords.insert(keyword)
                            } else {
                                selectedKeywords.remove(keyword)
                            }
                        }
                    )
                )
            }
        }
    }
}

#Preview {
    ArchiveView(snapshot: UIImage(named: "arrowRightWhite"))
        .environmentObject(Coordinator<WalkScreen>())
        .environmentObject(TabBarState())
}
