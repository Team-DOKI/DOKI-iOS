//
//  MyPageView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    var body: some View {
        ZStack {
            Color.defaultBright.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // 유저 & 반려견 프로필
                    MyProfile(
                        nickname: viewModel.userNameText,
                        email: viewModel.userEmailText,
                        action: viewModel.navigateToMyProfile
                    )
                    
                    PetProfile(
                        name: viewModel.petNameText,
                        petInfo: viewModel.petInfoText,
                        imageUrl: viewModel.petProfile?.imageUrl,
                        dbti: viewModel.petDbtiText,
                        profileAction: viewModel.navigateToPetProfile,
                        dbtiAction: viewModel.navigateToDbti
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
                .padding(.bottom, 80)
            }
        }
        .topNavigationView(center: {
            Text("마이페이지")
                .subtitle()
        })
        .customModal(
            isPresented: $viewModel.isShowLogoutAlert,
            message: "로그아웃",
            subMessage: "진짜로 로그아웃 하시게요? 😢",
            primaryTitle: "로그아웃",
            secondaryTitle: "취소",
            primaryAction: {
                Task {
                    await viewModel.logoutButtonConfirmed()
                }
            },
            secondaryAction: viewModel.logoutCancelButtonTapped
        )
        .customModal(
            isPresented: $viewModel.isShowWithdrawAlert,
            message: "탈퇴하기",
            subMessage: "진짜로 탈퇴하시게요? 😢",
            primaryTitle: "탈퇴하기",
            secondaryTitle: "취소",
            primaryAction: {
                Task {
                    await viewModel.withdrawButtonConfirmed()
                }
            },
            secondaryAction: viewModel.withdrawCancelButtonTapped
        )
        .onAppear {
            viewModel.fetchUserProfile()
            viewModel.fetchPetProfile(petId: 17)
        }
    }
}
