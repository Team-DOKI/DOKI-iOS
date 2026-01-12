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
                    // 유저 & 반려견 프로필
                    MyProfile(
                        nickname: "키큰오팔전차",
                        email: "hello@gmail.com",
                        action: viewModel.navigateToMyProfile
                    )
                    
                    PetProfile(
                        name: "단지",
                        dbti: "동네인기스타bbb",
                        petInfo: "6개월 / 여아 / 견종 이름",
                        action: viewModel.navigateToPetProfile
                    )
                    
                    // 산책 루트 관리
                    MenuSection(title: "산책 루트 관리") {
                        Group {
                            MenuItem(
                                title: "내가 기록한 산책",
                                icon:  Image(.icRecord),
                                action: viewModel.navigateToWalkRecord
                            )
                            MenuItem(
                                title: "저장목록",
                                icon:  Image(.icSave),
                                action: viewModel.navigateToSavedWalk
                            )
                            MenuItem(
                                title: "내가 남긴 후기",
                                icon:  Image(.icReview),
                                action: viewModel.navigateToReview
                            )
                        }
                    }
                    
                    // 설정
                    MenuSection(title: "설정") {
                        Group {
                            MenuItem(
                                title: "활동 범위 설정",
                                icon:  Image(.icLocation),
                                action: viewModel.navigateToActivityAreaSetting
                            )
                            MenuItem(
                                title: "앱 정보",
                                icon:  Image(.icInfo),
                                action: viewModel.navigateToAppInfo
                            )
                            MenuItem(
                                title: "로그아웃",
                                icon:  Image(.icLogout),
                                action: viewModel.logoutButtonTapped
                            )
                            MenuItem(
                                title: "탈퇴하기",
                                icon:  Image(.icQuit),
                                action: viewModel.withdrawButtonTapped
                            )
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
