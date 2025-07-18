//
//  CourseDetailView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

import Kingfisher

struct CourseDetailView: View {
    @StateObject private var sharedWalkCourseViewModel = SharedWalkCourseViewModel()
    
    @ObservedObject var viewModel: CourseDetailViewModel
    
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @EnvironmentObject var coordinator: Coordinator<WalkScene>
    @Environment(\.dismiss) private var dismiss
    
    var backButtonTapped: (() -> ())?
    
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
                Spacer().frame(height: 116)
            }
            .task {
                await viewModel.fetchCoruseDetail()
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
                if let imageUrl = viewModel.selectedImageUrl {
                    ZStack {
                        Color.black
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(maxWidth: .infinity, minHeight: 228, maxHeight: 228)
                }
            }
            .padding(.horizontal, 16)
        })
        .topNavigationView(left: {
            BackButton {
                if backButtonTapped == nil {
                    dismiss()
                    mainTabViewModel.isHidden = false
                } else {
                    backButtonTapped?()
                }
            }
        }, center: {
            Text("루트 상세정보")
                .font(.body_16_sb)
        })
        
        .fullScreenCover(isPresented: $viewModel.isShowSharedWalkCourseView) {
            SharedWalkCourseView(viewModel: sharedWalkCourseViewModel, showSharedWalkCourseView: $viewModel.isShowSharedWalkCourseView, routeId: viewModel.post?.routeId ?? 0) { distance, elapsedTime, stepCount, snapshot in
                coordinator.push(.sharedWalkCompletion(
                    distance: distance,
                    elapsedTime: elapsedTime,
                    stepCount: stepCount,
                    routeId: viewModel.post?.routeId ?? 0,
                    routeImageUrl: viewModel.post?.routeImageUrl
                ))
                sharedWalkCourseViewModel.resetTrackingData()
            }
        }
        .task {
            await viewModel.fetchCoruseDetail()
            await viewModel.fetchReviewsTop()
        }
    }
}

extension CourseDetailView {
    private var walkCourseImageView: some View {
        KFImage(URL(string: viewModel.post?.routeImageUrl ?? ""))
            .resizable()
            .frame(minHeight: 250, maxHeight: 250)
            .frame(maxWidth: .infinity)
            .aspectRatio(contentMode: .fit)
            .clipped()
    }
    
    private var titleView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Text(viewModel.post?.title ?? "")
                    .font(.head_20_sb)
                    .foregroundColor(.pawkeyBlack)
                Spacer()
                
                //                if let post = viewModel.post {
                //                    if post.author.id == 2 {
                //                        Image(viewModel.isPrivate ? .eyeSlashFill : .eyeFill)
                //                    } else {
                //                        // 내가 작성한 게시물이 아닌 경우
                //                        Image(post.isLiked ? .heartIconFill : .heartIconGray)
                //                    }
                //                }
                if (viewModel.post?.author.id == 2) {
                    if (viewModel.post?.isLiked ?? false) {
                        Image(.eyeFill)
                    } else {
                        Image(.eyeSlashFill)
                    }
                }
                else {
                    if (viewModel.post?.isLiked ?? false) {
                        Image(.heartIconFill)
                            .onTapGesture {
                                Task {
                                    await viewModel.unLikePost()
                                }
                            }
                    } else {
                        Image(.heartIconGray)
                            .onTapGesture {
                                Task {
                                    await viewModel.likePost()
                                }
                            }
                    }
                }
                
                
            }
        }
    }
    
    private var dogProfileView: some View {
        HStack(spacing: 10) {
            KFImage(URL(string: viewModel.post?.author.petProfileImage ?? ""))
                .resizable()
                .frame(maxWidth: 43, maxHeight: 43)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            
            Text(viewModel.post?.author.petName ?? "")
                .font(.body_16_sb)
                .foregroundColor(.pawkeyBlack)
        }
    }
    
    private var reviewImageScrollView: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    if let post = viewModel.post {
                        ForEach(post.walkingImageUrls, id: \.self) { imageUrl in
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(4)
                                .onTapGesture {
                                    viewModel.isShowPhotoPreview = true
                                    viewModel.selectedImageUrl = imageUrl
                                }
                        }
                    }
                    
                }
            }
            .padding(.bottom, 12)
            
            Text(viewModel.post?.content ?? "")
                .font(.body_14_r)
                .foregroundStyle(.pawkeyBlack)
                .padding(.bottom, 12)
            
            Text("본인 위치에서의 거리")
                .font(.caption_12_sb)
                .foregroundStyle(.gray200)
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
                    Text("\(viewModel.reviewCount)")
                        .font(.caption_12_m)
                        .foregroundStyle(.gray200)
                }
            }
            .padding(.vertical, 16)
            
            if viewModel.reviewCount == 0 {
                if viewModel.isPrivate == true {
                    Text("공개로 설정해보세요!")
                        .font(.head_18_sb)
                        .foregroundStyle(.gray300)
                        .padding(.vertical, 24)
                } else {
                    Text("아직 후기가 없어요.")
                        .font(.head_18_sb)
                        .foregroundStyle(.gray300)
                        .padding(.vertical, 24)
                }
            } else {
                VStack {
                    ForEach(viewModel.topReviews, id: \.self) {
                        ReviewRatingBar(title: $0.optionText, rating: $0.ratio, rank: $0.rank)
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
    
    private var locationDateInfoView: some View {
        VStack(alignment: .leading) {
            TimePlaceCell(type: .place(viewModel.post?.region ?? ""))
                .padding(.bottom, 4)
            
            TimePlaceCell(type: .time(viewModel.post?.createdDate ?? ""))
                .padding(.bottom, 12)
            
            FlexibleGrid(availableWidth: UIScreen.main.bounds.width - 32,
                         data: viewModel.post?.tags ?? [],
                         spacing: 8, alignment: .leading) {
                Chip(title: $0)
            }
        }
    }
    
    private var roundedView: some View {
        Rectangle()
            .frame(height: 20)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .offset(y: -10)
            .foregroundStyle(.white)
    }
}
