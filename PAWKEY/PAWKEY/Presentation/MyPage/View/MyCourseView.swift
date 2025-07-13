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
    @EnvironmentObject var router: Coordinator<MyPageScreen>
    
    @EnvironmentObject var tabBarState: TabBarState
    
    let tagList = ["이륜차 거의 없음", "배변 쓰레기통", "쉼터", "편의점", "동반 카페", "아스팔트/벽돌", "시끌벅적"]
    
    let myReviewList: [Review] = [
        Review(walkRouteImg: "walkRoute", profileImg: "profile6", walkTitle: "아시는구나~", petName: "포키", postDate: "2025/01/02", buttonPressed: true),
        Review(walkRouteImg: "walkRoute2", profileImg: "profile2", walkTitle: "신나는 산책", petName: "쮸비", postDate: "2025/03/04", buttonPressed: false),
        Review(walkRouteImg: "walkRoute3", profileImg: "profile3", walkTitle: "더운 산책", petName: "수민이누나", postDate: "2025/05/06", buttonPressed: true),
        Review(walkRouteImg: "walkRoute", profileImg: "profile4", walkTitle: "스꾸삐~", petName: "세민이", postDate: "2025/07/08", buttonPressed: false),
        Review(walkRouteImg: "walkRoute2", profileImg: "profile5", walkTitle: "그냥 산책", petName: "치즈", postDate: "2025/09/10", buttonPressed: false)
    ]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(myReviewList, id: \.id) { review in
                        ReviewCard(
                            type: .mine,
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
            Text("내가 기록한 산책 루트")
                .font(.body_16_sb)
        })
        .ignoresSafeArea(edges: .bottom)
        
    }
}

