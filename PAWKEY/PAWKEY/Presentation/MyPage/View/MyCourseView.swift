//
//  MyCourseView.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/13/25.
//

import SwiftUI

struct MyCourseView: View {
    @EnvironmentObject var router: Coordinator<MyPageScreen>
    let dummyData = ["이륜차 거의 없음", "배변 쓰레기통", "쉼터", "편의점", "동반 카페", "아스팔트/벽돌", "시끌벅적"]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ReviewCard(type: .mine, walkRouteImg: "walkRoute", profileImg: "profile6", walkTitle: "아시는구나~", petName: "포키", postDate: "2025/01/02", buttonPressed: true, data: dummyData)
                    ReviewCard(type: .mine, walkRouteImg: "walkRoute2", profileImg: "profile2", walkTitle: "신나는 산책", petName: "쮸비", postDate: "2025/03/04", buttonPressed: false, data: dummyData)
                    ReviewCard(type: .mine, walkRouteImg: "walkRoute3", profileImg: "profile3", walkTitle: "더운 산책", petName: "수민이누나", postDate: "2025/05/06", buttonPressed: true, data: dummyData)
                    ReviewCard(type: .mine, walkRouteImg: "walkRoute", profileImg: "profile4", walkTitle: "스꾸삐~", petName: "세민이", postDate: "2025/07/08", buttonPressed: false, data: dummyData)
                    ReviewCard(type: .mine, walkRouteImg: "walkRoute2", profileImg: "profile5", walkTitle: "그냥 산책", petName: "치즈", postDate: "2025/09/10", buttonPressed: false, data: dummyData)
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
