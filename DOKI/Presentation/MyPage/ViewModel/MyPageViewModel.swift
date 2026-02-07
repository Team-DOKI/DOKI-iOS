//
//  MyPageViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    var navigationAction: ((MyPageRoute)->())?
    
    @Published var isShowLogoutAlert: Bool = false
    @Published var isShowWithdrawAlert: Bool = false
    
    private let authManager: AuthManager
    
    init(authManager: AuthManager = .shared) {
        self.authManager = authManager
    }
    
    /// 로그아웃 모달 표시
    func logoutButtonTapped() {
        isShowLogoutAlert = true
    }
    
    /// 회원탈퇴 모달 표시
    func withdrawButtonTapped() {
        isShowWithdrawAlert = true
    }
    
    /// 로그아웃 취소
    func logoutCancelButtonTapped() {
        isShowLogoutAlert = false
    }
    
    /// 회원탈퇴 취소
    func withdrawCancelButtonTapped() {
        isShowWithdrawAlert = false
    }
    
    /// 회원탈퇴 처리
    func withdrawButtonConfirmed() {
        isShowWithdrawAlert = false
        
        Task {
            await authManager.withdraw()
        }
    }
    
    /// 로그아웃 처리
    func logoutButtonConfirmed() {
        isShowLogoutAlert = false
        
        Task {
            await authManager.logout()
        }
    }
    
    // MARK: - Navigation
    
    func navigateToPetProfile() {
        navigationAction?(.petProfile)
    }
    
    func navigateToMyProfile() {
        navigationAction?(.myProfile)
    }
    
    func navigateToWalkRecord() {
        navigationAction?(.walkRecord)
    }
    
    func navigateToSavedWalk() {
        navigationAction?(.savedWalk)
    }
    
    func navigateToReview() {
        navigationAction?(.review)
    }
    
    func navigateToActivityAreaSetting() {
        navigationAction?(.activityAreaSetting)
    }
    
    func navigateToAppInfo() {
        navigationAction?(.appInfo)
    }
}
