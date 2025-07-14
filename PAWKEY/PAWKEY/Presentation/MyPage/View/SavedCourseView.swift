//
//  SavedRouteView.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/11/25.
//

import SwiftUI

struct SavedCourseView: View {
    @EnvironmentObject var router: Coordinator<MyPageScene>
    @EnvironmentObject var tabBarState: MainTabViewModel
    
    let tagList = ["이륜차 거의 없음", "배변 쓰레기통", "쉼터", "편의점", "동반 카페", "아스팔트/벽돌", "시끌벅적"]
    let otherReviewList: [Review] = [
        Review(walkRouteImg: "walkRoute", profileImg: "profile", walkTitle: "외로운 산책", petName: "길냥이", postDate: "2025/01/02", buttonPressed: true),
        Review(walkRouteImg: "walkRoute2", profileImg: "profile2", walkTitle: "신나는 산책", petName: "쮸비", postDate: "2025/03/04", buttonPressed: true),
        Review(walkRouteImg: "walkRoute3", profileImg: "profile3", walkTitle: "더운 산책", petName: "수민이누나", postDate: "2025/05/06", buttonPressed: true),
        Review(walkRouteImg: "walkRoute", profileImg: "profile4", walkTitle: "스꾸삐~", petName: "세민이", postDate: "2025/07/08", buttonPressed: true),
        Review(walkRouteImg: "walkRoute2", profileImg: "profile5", walkTitle: "그냥 산책", petName: "치즈", postDate: "2025/09/10", buttonPressed: true)
    ]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(otherReviewList, id : \.id) { review in
                        ReviewCard(
                            type: .others,
                            walkRouteImg: review.walkRouteImg,
                            profileImg: review.profileImg,
                            walkTitle: review.walkTitle,
                            petName: review.petName,
                            postDate: review.postDate,
                            buttonPressed: review.buttonPressed,
                            data: tagList
                        )
                        .onTapGesture {
                            router.push(.courseDetail)
                            tabBarState.isHidden = true
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
                router.pop()
            }
        }, center: {
            Text("저장한 산책 루트")
                .font(.body_16_sb)
        })
        .ignoresSafeArea(edges: .bottom)
        
    }
}
