//
//  MyPageView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    var body: some View {
        ZStack {
            Color.defaultBright.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    MyProfile(
                        nickname: "키큰오팔전차",
                        email: "hello@gmail.com",
                        action: {}
                    )
                    
                    PetProfile(
                        name: "단지",
                        dbti: "동네인기스타bbb",
                        petInfo: "6개월 / 여아 / 견종 이름",
                        action: {}
                    )
                    
                    MenuSection(title: "산책 루트 관리") {
                        Group {
                            MenuItem(title: "내가 기록한 산책", icon:  Image(.icRecord), action: {})
                            MenuItem(title: "저장목록", icon:  Image(.icSave), action: {})
                            MenuItem(title: "내가 남긴 후기", icon:  Image(.icReview), action: {})
                        }
                    }
                    
                    MenuSection(title: "설정") {
                        Group {
                            MenuItem(title: "활동 범위 설정", icon:  Image(.icLocation), action: {})
                            MenuItem(title: "앱 정보", icon:  Image(.icInfo), action: {})
                            MenuItem(title: "로그아웃", icon:  Image(.icLogout), action: {})
                            MenuItem(title: "탈퇴하기", icon:  Image(.icQuit), action: {})
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 22)
            }
        }
        .topNavigationView(center: {
            Text("마이페이지")
                .subtitle()
        })
    }
}

#Preview {
    MyPageView(viewModel: MyPageViewModel())
}
