//
//  ReviewWriteView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct ReviewWriteView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject private var viewModel: ReviewWriteViewModel
    
    @State private var isAlertPresented: Bool = false
    
    init(viewModel: ReviewWriteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    Text("제목")
                        .font(.head_20_sb)
                        .foregroundStyle(.green500)
                        .padding(.vertical, 12)
                    
                    HStack(alignment: .center, spacing: 10) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 43, height: 43)
                        
                        Text("포비")
                            .font(.body_16_sb)
                        
                    }
                    .padding(.vertical, 12)
                    
                    TimePlaceCell(type: .place("강남구 역삼동"))
                        .padding(.bottom, 4)
                    
                    TimePlaceCell(type: .time("2025.07.08(화) | 오후 11:28"))
                        .padding(.bottom, 12)
                    
                    Chip(title: "옵션")
                        .padding(.top, 10)
                        .padding(.bottom, 16)
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
                        ForEach(viewModel.categories, id: \.categoryId) { category in
                            QuestionForm(
                                question: category.categoryDescription,
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
                
                CTAButton(
                    title: "산책 후기 남기기",
                    isDisabled: !viewModel.isButtonDisabled,
                    buttonStyle: .filled
                ) {
                    isAlertPresented = true
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
            .topNavigationView(center: {
                Text("산책 후기 작성")
                    .font(.body_16_sb)
            })
            .onAppear {
                Task {
                    await viewModel.fetchCourseCategories()
                }
            }
            .contextMenu(isPresented: $isAlertPresented) {
                Alert(
                    title: "후기가 등록되었어요!",
                    description: "덕분에 PAWKEY가 보호자님을 더 잘 알게 됐어요.\n이 정보로 다음엔 더 완벽한 경로를 추천해 드릴게요.",
                    confirmButton: CTAButton(
                        title: "확인",
                        isDisabled: false,
                        buttonStyle: .filled
                    ) {
                        isAlertPresented = false
                        coordinator.popToRoot()
                        mainTabViewModel.isHidden = false
                    }
                ).padding(.horizontal, 19)
            }
        }
    }
}
