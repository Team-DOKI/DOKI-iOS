//
//  MyPageViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import Foundation
import SwiftUI

import Moya

class MyPageViewModel: ObservableObject {
    private let userAPIService: UserAPIServiceProtocol
    private let authManager: AuthManager
    
    init(
        userAPIService: UserAPIServiceProtocol = UserAPIService(),
        authManager: AuthManager = .shared
    ) {
        self.userAPIService = userAPIService
        self.authManager = authManager
    }
    
    @Published var isShowLogoutAlert: Bool = false
    @Published var isShowWithdrawAlert: Bool = false
    
    @Published var userProfile: UserProfileResponse?
    @Published var petProfile: PetProfileResponse?
    
    // MARK: - Computed Properties (UI)
    
    var userNameText: String { userProfile?.name ?? "" }
    var userEmailText: String { userProfile?.email ?? "" }
    var userBirthText: String { userProfile?.birth ?? "" }
    var userGenderText: String { userProfile?.gender ?? "" }
    
    var petNameText: String { petProfile?.name ?? "" }
    var petDbtiText: String {
        if let name = petProfile?.dbtiName,
           let description = petProfile?.dbtiDescription {
            return "\(name) | \(description)"
        }
        return "DBTI 검사하러 가기"
    }
    var petInfoText: String {
        guard let pet = petProfile else { return "" }
        let genderText = pet.gender == "F" ? "여아" : "남아"
        return "\(pet.age) / \(genderText) / \(pet.breed)"
    }
    
    // MARK: - User Action
    
    /// 로그아웃 모달 표시
    func logoutButtonTapped() {
        isShowLogoutAlert = true
    }
    
    /// 회원탈퇴 모달 표시
    func withdrawButtonTapped() {
        isShowWithdrawAlert = true
    }
    
    /// 로그아웃 처리
    func logoutButtonConfirmed() async {
        await MainActor.run {
            isShowLogoutAlert = false
        }
        
        await authManager.logout()
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
    func withdrawButtonConfirmed() async {
        await MainActor.run {
            isShowWithdrawAlert = false
        }
        
        await authManager.withdraw()
    }
    
    // MARK: - Navigation
    
    var navigationAction: ((MyPageRoute)->())?
    
    func navigateToPetProfile() {
        navigationAction?(.petProfile)
    }
    
    func navigateToMyProfile() {
        guard userProfile != nil else {
            return
        }
        navigationAction?(.myProfile)
    }
    
    func navigateToDbti() {
        if petProfile?.dbtiName != nil {
            navigationAction?(.dbtiResult)
        } else {
            navigationAction?(.dbtiStart)
        }
    }
    
    func navigateToWalkRecord() {
        navigationAction?(.myWalkRecord)
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

// MARK: - API

extension MyPageViewModel {
    /// 유저 정보 조회
    func fetchUserProfile() {
        userAPIService.fetchUserProfile { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.userProfile = response?.data
                default:
                    print("유저 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    /// 반려견 정보 조회
    func fetchPetProfile(petId: Int) {
        userAPIService.fetchPetProfile(petId: petId) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.petProfile = response?.data
                default:
                    print("반려견 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
}
