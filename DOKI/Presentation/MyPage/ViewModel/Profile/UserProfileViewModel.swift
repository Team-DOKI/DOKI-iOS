//
//  UserProfileViewModel.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI
import Combine

class UserProfileViewModel: ObservableObject {
    private let profileAPIService: ProfileAPIServiceProtocol
    
    init(
        profileAPIService: ProfileAPIServiceProtocol = ProfileAPIService(),
        
        userProfile: UserProfileResponse
    ) {
        self.profileAPIService = profileAPIService
        
        self.nickname = userProfile.name
        self.birthDay = userProfile.birth.replacingOccurrences(of: "-", with: "/")
        self.gender = Gender(rawValue: userProfile.gender) ?? .female
        
        observeNickname()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var nickname: String
    @Published var birthDay: String
    @Published var gender: Gender
    
    @Published var isNicknameAvailable: Bool?
    @Published var nicknameMessage: String = ""
    
    @Published var isSaveCompleted = false
    
    var buttonDisabled: Bool {
        nickname.isEmpty || birthDay.isEmpty || isNicknameAvailable == false
    }
    
    func selecteGender(_ gender: Gender) {
        self.gender = gender
    }
    
    private func observeNickname() {
        $nickname
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] nickname in
                guard let self else { return }
                
                if nickname.isEmpty { return }
                self.checkNicknameDuplicate()
            }
            .store(in: &cancellables)
    }
    
    func saveButtonTapped() {
        updateUserProfile()
    }
}

// MARK: - API

extension UserProfileViewModel {
    /// 유져 정보 수정
    func updateUserProfile() {
        let formattedBirthDay = birthDay.replacingOccurrences(of: "/", with: "-")
        
        let request = UpdateUserProfileRequest(
            name: nickname,
            birth: formattedBirthDay,
            gender: gender.serverValue
        )
        
        profileAPIService.updateUserProfile(request: request) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.isSaveCompleted = true
                }
                
            default:
                print("유저 정보 수정에 실패했습니다.")
            }
        }
    }
    
    /// 닉네임 중복 검사
    func checkNicknameDuplicate() {
        guard !nickname.isEmpty else { return }
        
        profileAPIService.checkNicknameDuplicate(nickname: nickname) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isNicknameAvailable = true
                    self.nicknameMessage = ""
                    
                default:
                    self.isNicknameAvailable = false
                    self.nicknameMessage = "* 이미 존재하는 닉네임입니다"
                }
            }
        }
    }
}
