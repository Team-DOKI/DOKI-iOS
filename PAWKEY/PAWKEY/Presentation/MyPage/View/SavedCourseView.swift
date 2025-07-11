//
//  SavedRouteView.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/11/25.
//

import SwiftUI

struct SavedCourseView: View {
    @EnvironmentObject var router: Coordinator<MyPageScreen>
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ReviewCard(type: .others, walkRouteImg: "walkRoute", profileImg: "profile", walkTitle: "외로운 산책", petName: "길냥이", postDate: "2025/01/02", buttonPressed: true)
                    ReviewCard(type: .others, walkRouteImg: "walkRoute2", profileImg: "profile2", walkTitle: "신나는 산책", petName: "쮸비", postDate: "2025/03/04", buttonPressed: true)
                    ReviewCard(type: .others, walkRouteImg: "walkRoute3", profileImg: "profile3", walkTitle: "더운 산책", petName: "수민이누나", postDate: "2025/05/06", buttonPressed: true)
                    ReviewCard(type: .others, walkRouteImg: "walkRoute", profileImg: "profile4", walkTitle: "스꾸삐~", petName: "세민이", postDate: "2025/07/08", buttonPressed: true)
                    ReviewCard(type: .others, walkRouteImg: "walkRoute2", profileImg: "profile5", walkTitle: "그냥 산책", petName: "치즈", postDate: "2025/09/10", buttonPressed: true)
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
