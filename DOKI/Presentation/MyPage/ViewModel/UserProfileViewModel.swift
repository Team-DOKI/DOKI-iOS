//
//  UserProfileViewModel.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

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
    }
    
    @Published var nickname: String
    @Published var birthDay: String
    @Published var gender: Gender
    
    @Published var isSaveCompleted = false
    
    func selecteGender(_ gender: Gender) {
        self.gender = gender
    }
    
    func saveButtonTapped() {
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
}
