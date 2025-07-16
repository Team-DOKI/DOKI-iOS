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
                if let image = viewModel.selectedImage {
                    ZStack {
                        Color.black
                        Image(uiImage: image)
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
                mainTabViewModel.isHidden = false
                dismiss()
            }
        }, center: {
            Text("루트 상세정보")
                .font(.body_16_sb)
        })
        .overlay(alignment: .bottom) {
            submitButton
        }
        .fullScreenCover(isPresented: $viewModel.isShowSharedWalkCourseView) {
            SharedWalkCourseView(viewModel: sharedWalkCourseViewModel, showSharedWalkCourseView: $viewModel.isShowSharedWalkCourseView) { distance, elapsedTime, stepCount, snapshot in
                coordinator.push(.sharedWalkCompletion(
                    distance: distance,
                    elapsedTime: elapsedTime,
                    stepCount: stepCount,
                    snapshot: snapshot
                ))
                sharedWalkCourseViewModel.resetTrackingData()
            }
        }
        .task {
            await viewModel.fetchCoruseDetail()
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
                if (viewModel.post?.isLiked ?? false) {
                    Image(.heartIconFill)
                } else {
                    Image(.heartIconGray)
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
            if viewModel.images.count > 1 {
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
            }
            
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
    
    private var submitButton: some View {
        Button(action: {
            viewModel.isShowSharedWalkCourseView = true
        }) {
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
