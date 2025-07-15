//
//  ReviewWriteView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct ReviewWriteView: View {
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
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
                        QuestionForm(
                            question: "🚸 산책 중 안전 요소는 어땠나요?",
                            tags: [
                                "킥보드나 자전거가 거의 없어요",
                                "차량이 거의 다니지 않아요",
                                "야간 조명이 잘 되어있어요",
                                "보도와 차도가 구분되어 있어요",
                                "보도가 넓어서 산책하기 편했어요"
                            ],
                            selectedTags: $viewModel.safetyTags
                        )
                        
                        QuestionForm(
                            question: "🧺 산책 중 어떤 편의 시설이 있었나요?",
                            tags: [
                                "배변 봉투 쓰레기통이 있어요",
                                "애견 산책로가 있어요",
                                "쉴 곳이 있어요",
                                "편의점이 있어요",
                                "반려견 동반 가능한 카페가 있어요"
                            ],
                            selectedTags: $viewModel.facilityTags
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
                    }
                ).padding(.horizontal, 19)
            }
        }
    }
}
