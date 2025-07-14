//
//  SavedRouteView.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/11/25.
//

import SwiftUI

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
                    ForEach(viewModel.otherReviewList, id : \.id) { review in
                        ReviewCard(
                            type: .others,
                            walkRouteImg: review.walkRouteImg,
                            profileImg: review.profileImg,
                            walkTitle: review.walkTitle,
                            petName: review.petName,
                            postDate: review.postDate,
                            buttonPressed: review.buttonPressed,
                            data: viewModel.tagList
                        )
                        .onTapGesture {
                            coordinator.push(.courseDetail)
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
        .ignoresSafeArea(edges: .bottom)
        
    }
}
