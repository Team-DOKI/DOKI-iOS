//
//  MyPageView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct MyPageView: View {
    @ObservedObject var viewModel: MyPageViewModel
    
    // TODO: 임시 더미데이터 API 연동시 제거
    @State var checkItems: [CheckItem] = [
        .init(isChecked: false, text: "요즘 산책을 잘 안해요"),
        .init(isChecked: false, text: "사용을 잘 안하게 돼요"),
        .init(isChecked: false, text: "기능이 복잡해 사용이 어려워요"),
        .init(isChecked: false, text: "원하는 기능이 없어요"),
        .init(isChecked: false, text: "다른 서비스를 사용 중이에요"),
        .init(isChecked: false, text: "기타"),
    ]
    @State var selectedItem: CheckItem?
    
    var body: some View {
        ZStack {
            Color.defaultBright.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // 유저 및 반려견 프로필
                    UserProfile(
                        nickname: viewModel.userNameText,
                        email: viewModel.userEmailText,
                        action: viewModel.navigateToUserProfile
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
                                title: "산책 지역 설정",
                                icon:  Image(.icLocation),
                                action: viewModel.navigateToRegionSetting
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
            content: {
                CustomModalView(
                    message: "로그아웃",
                    subMessage: "진짜로 로그아웃 하시게요?",
                    primaryTitle: "로그아웃",
                    secondaryTitle: "취소",
                    primaryAction: { Task { await viewModel.logoutButtonConfirmed() }},
                    secondaryAction:viewModel.logoutCancelButtonTapped
                )
            })
        .customModal(
            isPresented: $viewModel.isShowWithdrawAlert,
            content: {
                CustomModalView(
                    message: "탈퇴하기",
                    subMessage: "진짜로 탈퇴하시게요",
                    primaryTitle: "탈퇴하기",
                    secondaryTitle: "취소",
                    primaryAction: { Task { await viewModel.withdrawButtonConfirmed()} },
                    secondaryAction:viewModel.withdrawCancelButtonTapped,
                )
            })
        .customModal(
            isPresented: $viewModel.isShowWithdrawReasonAlert,
            content: {
                WithdrawReasonView(
                    checkItems: checkItems,
                    selectedItem: $selectedItem,
                    primaryButtonAction: viewModel.withdrawReasonCancel,
                    secondaryButtonAction: viewModel.withdrawReasonCompleted
                )
        })
        .onAppear {
            viewModel.fetchUserProfile()
            viewModel.fetchPetProfile(petId: AuthManager.shared.petId)
        }
    }
}
