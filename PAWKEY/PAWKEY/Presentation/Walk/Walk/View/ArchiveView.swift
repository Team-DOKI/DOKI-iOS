//
//  ArchiveView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI
import PhotosUI

struct ArchiveView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject private var viewModel = ArchiveViewModel()
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    
    let snapshot: UIImage?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if let snapshot = snapshot {
                                                    Image(uiImage: snapshot)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 160, height: 188)
                                                        .cornerRadius(8)
                                                } else {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .frame(width: 160, height: 188)
                                                }
                        
                        ForEach(viewModel.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 188)
                                .clipped()
                                .cornerRadius(8)
                        }
                        
                        if viewModel.selectedImages.count < 4 {
                            PhotosPicker(selection: $viewModel.selectedItems,
                                         maxSelectionCount: 4 - viewModel.selectedImages.count,
                                         matching: .images) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray5)
                                    .frame(width: 160, height: 188)
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
                
                LocationDateView()
                
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
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(maxWidth: .infinity)
                        .frame(height: 214)
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question)
                .font(.body_16_m)
                .foregroundColor(.pawkeyBlack)
                .padding(.bottom, 12)
            
            FlowLayout(spacing: 8) {
                ForEach(keywords, id: \.self) { keyword in
                    Text(keyword)
                        .font(.body_14_r)
                        .foregroundColor(.gray400)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray50, lineWidth: 1)
                        )
                }
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    // 전체 레이아웃 크기 계산
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        
        var x: CGFloat = 0 // 현재 줄에 채워진 너비
        var y: CGFloat = 0 // 누적 높이
        var lineHeight: CGFloat = 0 // 현재 줄에서 가장 큰 높이

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            // // 현재 줄 너비 넘으면 다음 줄로 이동
            if x + size.width > maxWidth {
                x = 0
                y += lineHeight + spacing
                lineHeight = 0
            }

            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }

        // 마지막 줄 높이 더하기
        return CGSize(width: maxWidth, height: y + lineHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if x + size.width > maxWidth {
                // 다음 줄로
                x = 0
                y += lineHeight + spacing
                lineHeight = 0
            }

            subview.place(
                at: CGPoint(x: bounds.minX + x, y: bounds.minY + y),
                proposal: ProposedViewSize(size)
            )

            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
