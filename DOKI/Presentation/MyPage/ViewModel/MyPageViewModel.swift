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
    var navigationAction: ((MyPageRoute)->())?
    
    @Published var isShowLogoutAlert: Bool = false
    @Published var isShowWithdrawAlert: Bool = false
    
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userBirth: String = ""
    @Published var userGender: String = ""

    @Published var petProfile: PetProfileResponseDTO?
    
    var petName: String { petProfile?.name ?? "" }
    var petDbti: String { petProfile?.dbtiName ?? "" }
    var petInfo: String {
        guard let pet = petProfile else { return "" }
        let genderText = pet.gender == "F" ? "여아" : "남아"
        return "\(pet.age) / \(genderText) / \(pet.breed)"
    }
    
    private let authManager: AuthManager
    private let provider = MoyaProvider<UserAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    init(authManager: AuthManager = .shared) {
        self.authManager = authManager
        fetchUserProfile()
        
        if let petId = UserDefaults.standard.value(forKey: "petId") as? Int {
                fetchPetProfile(petId: petId)
            } else {
                print("petId 없음")
            }
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
    func withdrawButtonConfirmed() async {
        isShowWithdrawAlert = false
        
        await authManager.withdraw()
        
    }
    
    /// 로그아웃 처리
    func logoutButtonConfirmed() async {
        isShowLogoutAlert = false
        
        await authManager.logout()
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

// MARK: - API

extension MyPageViewModel {
    func fetchUserProfile() {
        provider.request(.fetchUserProfile) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder()
                        .decode(BaseDTO<UserProfileResponseDTO>.self, from: response.data)
                    
                    DispatchQueue.main.async {
                        if let userData = decoded.data {
                            self.userName = userData.name
                            self.userEmail = userData.email
                            self.userBirth = userData.birth
                            self.userGender = userData.gender
                        }
                    }
                } catch {
                    print("유저 프로필 디코딩 실패:", error)
                }
                
            case .failure(let error):
                print("유저 프로필 조회 실패:", error.localizedDescription)
            }
        }
    }
    
    func fetchPetProfile(petId: Int) {
        provider.request(.fetchPetProfile(petId: petId)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(BaseDTO<PetProfileResponseDTO>.self, from: response.data)
                    DispatchQueue.main.async {
                        self.petProfile = decoded.data
                    }
                } catch {
                    print("펫 프로필 디코딩 실패:", error)
                }
            case .failure(let error):
                print("펫 프로필 조회 실패:", error.localizedDescription)
            }
        }
    }
}
