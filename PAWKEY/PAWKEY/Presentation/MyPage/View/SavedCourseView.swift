//
//  SavedRouteView.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/11/25.
//

import SwiftUI

import Kingfisher

struct SavedCourseView: View {
    @EnvironmentObject var coordinator: Coordinator<MyPageScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    @StateObject var viewModel: SavedCourseViewModel
    
    init(viewModel: SavedCourseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(viewModel.savedCourses) { course in
                        ReviewCard(
                            type: .others,
                            walkRouteImg: course.imageUrl,
                            profileImg: course.petImageUrl,
                            walkTitle: course.title,
                            petName: course.petName,
                            postDate: course.createdAt,
                            buttonPressed: course.isLiked,
                            data: course.tags
                        )
                        .onTapGesture {
                            coordinator.push(.courseDetail(postId: course.id))
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
            }
        }, center: {
            Text("저장한 산책 루트")
                .font(.body_16_sb)
        })
        .onAppear() {
            Task {
                await viewModel.fetchSavedCourses()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        
    }
}
