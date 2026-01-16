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
        print("회원탈퇴")
    }
    
    /// 로그아웃 처리
    func logoutButtonConfirmed() {
        print("로그아웃")
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
