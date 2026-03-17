//
//  RouteDetailView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import Kingfisher

struct RouteDetailView: View {
    @ObservedObject var viewModel: RouteDetailViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // TODO: 임시 지도 영역
            ZStack(alignment: .bottom) {
                mapView
                
                titleSection
                    .redacted(reason: viewModel.loadingStatus == .loading ? .placeholder : [])
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                
                profileSection
                
                Divider()
                
                walkInfoSection
                
                divider
                
                reviewSection
                
                divider
                
                reviewRatingSection
                
                divider
                
                buttonSection
                
                Spacer().frame(height: 40)
            }
            .redacted(reason: viewModel.loadingStatus == .loading ? .placeholder : [])
        }
        .overlay(alignment: .top, content: {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.defaultButton)
        })
        .topNavigationView {
            BackButton(action: viewModel.navigateToBack)
        } center: {
            Text("루트 상세 정보")
                .subtitle()
        }
        .onAppear {
            viewModel.fetchPost()
        }
        .onChange(of: viewModel.isPublic) { isPublic in
            if isPublic {
                viewModel.fetchReview()
            }
        }
        .ignoresSafeArea(.container, edges: [.bottom])
    }
}

extension RouteDetailView {
    private var mapView: some View {
        KFImage(URL(string: viewModel.routeImageURL))
            .placeholder { Color.gray.opacity(0.3) }
            .onFailure { _ in }
            .resizable()
            .frame(height: 292)
    }
    
    private var titleSection: some View {
        Text(viewModel.title)
            .header3()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(16, corners: [.topLeft, .topRight])
    }
    
    private var profileSection: some View {
        HStack(spacing: 10) {
            
            KFImage(URL(string: viewModel.petProfileImageURL))
                .placeholder {
                    Color.gray.opacity(0.3)
                }
                .resizable()
                .frame(width: 43, height: 43)
                .clipShape(Circle())
            
            Text(viewModel.petName)
                .subtitle(color: .defaultDark)
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var walkInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
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
            
            if viewModel.isExpanded {
                FlexibleGrid(availableWidth: UIScreen.main.bounds.width - 70,
                             data: viewModel.tagList,
                             spacing: 8,
                             alignment: .leading) { tagName in
                    RouteTag(text: tagName)
                }
                             .padding(.vertical, 10)
            } else {
                HStack(spacing: 8) {
                    ForEach(viewModel.tagList.prefix(4), id: \.self) { tagName in
                        RouteTag(text: tagName)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 10)
            }
            
            if viewModel.tagList.count > 4 && !viewModel.isExpanded {
                HStack(spacing: 5) {
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)
                    
                    Text("+ \(viewModel.tagList.count - 4)")
                        .bodySmall(color: .defaultMiddle)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .clipShape(Capsule())
                        .background(.defaultButton)
                        .clipShape(Capsule())
                    
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)
                }
                .onTapGesture {
                    viewModel.isExpanded = true
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: 8)
            .foregroundStyle(.defaultButton)
    }
    
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(viewModel.walkImageUrls, id: \.self) { url in
                        KFImage(URL(string: url))
                            .resizable()
                            .frame(width: 110, height: 110)
                            .background(.gray)
                    }
                }
            }
            
            Text(viewModel.description)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var reviewRatingSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("이런 점이 좋았어요")
                    .mainActive()
                
                Label(title: {
                    Text("\(viewModel.totalReviewCount)개의 후기")
                }, icon: {
                    Image(.icEdit)
                })
                .font(.subDefault)
                .foregroundStyle(.defaultMiddle)
                
                Spacer()
            }
            .padding(.vertical, 16)
            
            VStack(spacing: 10) {
                if viewModel.isPublic {
                    VStack {
                        ForEach(viewModel.reviews, id: \.self.rank) { review in
                            ReviewChart(text: review.optionText, rank: review.rank)
                        }
                    }
                } else {
                    Text("현재는 비공개 상태에요.\n공개로 전환해 산책 루트를 공유해보세요.")
                        .subtitle(color: .defaultMiddle)
                }
            }
            .padding(.vertical, 12)
        }
        .padding(.horizontal, 16)
    }
    
    private var buttonSection: some View {
        HStack(spacing: 8) {
            if viewModel.isMine {
                Button {
                    
                } label: {
                    Text("삭제하기")
                        .subtitle(color: .defaultRed)
                        .frame(maxWidth: .infinity, maxHeight: 56)
                }
                .overlay(
                    RoundedCorner(radius: 8)
                        .stroke(.defaultRed, lineWidth: 1)
                )
                
                MainButton(text: "수정하기")
            } else {
                MainButton(text: "해당 루트로 산책하기") {
                    viewModel.navigateToFollowRouteFollowRoute()
                }
            }
        }
        .padding(.top, 40)
        .padding(.horizontal, 16)
    }
    
}
