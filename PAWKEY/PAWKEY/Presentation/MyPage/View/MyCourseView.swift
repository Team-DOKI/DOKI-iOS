//
//  MyCourseView.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/13/25.
//

import SwiftUI

struct Review: Identifiable {
    let id = UUID()
    let walkRouteImg: String
    let profileImg: String
    let walkTitle: String
    let petName: String
    let postDate: String
    var buttonPressed: Bool
}

struct MyCourseView: View {
    @EnvironmentObject var coordinator: Coordinator<MyPageScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject var viewModel: MyCourseViewModel
    
    init(viewModel: MyCourseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(viewModel.myCourses, id: \.id) { review in
                        ReviewCard(
                            type: .mine,
                            walkRouteImg: review.imageUrl,
                            profileImg: review.petImageUrl,
                            walkTitle: review.title,
                            petName: review.petName,
                            postDate: review.createdAt,
                            buttonPressed: review.isLiked,
                            data: review.tags
                        )
                        .onTapGesture {
//                            coordinator.push(.courseDetail(postId: review.id))
                            mainTabViewModel.isHidden = true
                        }
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 108)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.pawkeyWhite2)
        .topNavigationView(left: {
            BackButton {
                coordinator.pop()
                mainTabViewModel.isHidden = false
            }
        }, center: {
            Text("내가 기록한 산책 루트")
                .font(.body_16_sb)
        })
        .onAppear() {
            Task {
                await viewModel.fetchMyCourses()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        
    }
}

