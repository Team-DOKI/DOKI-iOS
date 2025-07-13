//
//  CourseDetailView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct CourseDetailView: View {
    @ObservedObject var viewModel: CourseDetailViewModel
    @EnvironmentObject var tabBarstate: TabBarState
    @EnvironmentObject var router: Coordinator<HomeScreen>
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                walkCourseImageView
                roundedView
                VStack(alignment: .leading, spacing: 0) {
                    titleView
                        .padding(.bottom, 16)
                        .padding(.top, -10)
                    Divider()
                    dogProfileView
                        .padding(.vertical, 12)
                    locationDateInfoView
                        .padding(.vertical, 12)
                    Divider()
                    reviewImageScrollView
                        .padding(.vertical, 20)
                }
                .padding(.horizontal, 16)
                divider
                reviewChartView
                    .padding(.horizontal, 16)
                divider
                Spacer().frame(height: 70)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .contextMenu(isPresented: $viewModel.isShowPhotoPreview, content: {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        viewModel.isShowPhotoPreview = false
                    } label: {
                        Image(.xmark)
                    }

                }
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(maxHeight: 228)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding(.horizontal, 16)
        })
        .topNavigationView(left: {
            BackButton {
                tabBarstate.isHidden = false
                router.pop()
            }
        }, center: {
            Text("루트 상세 정보")
                .font(.body_16_sb)
        })
        .overlay(alignment: .bottom) {
            submitButton
        }
    }
}

extension CourseDetailView {
    private var walkCourseImageView: some View {
        Group {
            if let snapshot = viewModel.images.first {
                Image(uiImage: snapshot)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.pawkeyWhite2)
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var titleView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Text("제목 제목 제목")
                    .font(.head_20_sb)
                    .foregroundColor(.pawkeyBlack)
                Spacer()
                if viewModel.isPrivate {
                    Image(.heartIconFill)
                } else {
                    Image(.heartIconGray)
                }
            }
        }
    }
    
    private var dogProfileView: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color.green)
                .frame(width: 43, height: 43)
            
            Text("강아지 이름")
                .font(.body_16_sb)
                .foregroundColor(.pawkeyBlack)
        }
    }
    
    private var reviewImageScrollView: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(viewModel.images.dropFirst(), id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(4)
                            .onTapGesture {
                                viewModel.isShowPhotoPreview = true
                                viewModel.selectedImage = image
                            }
                    }
                }
            }
            .padding(.bottom, 12)
            
            Text("""
                 후기 글 본문 후기 글 본문 후기 글 본문ㅇ
                 후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ후기 글 본문 후기 글 본문 후기 글 본문ㅇ
                """)
            .font(.body_14_r)
            .foregroundStyle(.pawkeyBlack)
            .padding(.bottom, 12)
            
            Text("본인 위치에서의 거리")
                .font(.caption_12_sb)
                .foregroundStyle(.gray200)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.pawkeyWhite2)
            .frame(height: 10)
            .frame(maxWidth: .infinity)
    }
    
    private var reviewChartView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("이런 점이 좋았어요")
                    .font(.head_18_sb)
                    .foregroundStyle(.pawkeyBlack)
                HStack(spacing: 4) {
                    Image(.editIconGray)
                    Text("후기 숫자")
                        .font(.caption_12_m)
                        .foregroundStyle(.gray200)
                }
            }
            .padding(.vertical, 16)
            
            VStack {
                ReviewRatingBar(title: "후기", rating: 0.6, rank: 1)
                ReviewRatingBar(title: "후기", rating: 0.3, rank: 2)
                ReviewRatingBar(title: "후기", rating: 0.2, rank: 3)
            }
            .padding(.bottom, 24)
        }
    }
    
    private var locationDateInfoView: some View {
        VStack(alignment: .leading) {
            TimePlaceCell(type: .place("강남구 역삼동"))
            TimePlaceCell(type: .time("2025.07.08(화) | 오후 11:28"))
            Chip(title: "옵션")
        }
    }
    
    private var submitButton: some View {
        Button(action: {}) {
            Text("해당 루트로 산책하기")
                .font(.body_16_sb)
                .foregroundStyle(.pawkeyWhite1)
                .frame(maxWidth: .infinity, minHeight: 56)
        }
        .background(.green500)
    }
    
    private var roundedView: some View {
        Rectangle()
            .frame(height: 20)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .offset(y: -10)
            .foregroundStyle(.white)
    }
}
