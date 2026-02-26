//
//  MyProfileViewModel.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

class MyProfileViewModel: ObservableObject {
    private let userAPIService: UserAPIServiceProtocol
    
    init(
        userProfile: UserProfileResponse,
        userAPIService: UserAPIServiceProtocol = UserAPIService()
    ) {
        self.nickname = userProfile.name
        self.birthDay = userProfile.birth.replacingOccurrences(of: "-", with: "/")
        self.gender = Gender(rawValue: userProfile.gender) ?? .female
        self.userAPIService = userAPIService
    }
    
    @Published var nickname: String
    @Published var birthDay: String
    @Published var gender: Gender
    
    @Published var isSaveCompleted = false
    
    func selecteGender(_ gender: Gender) {
        self.gender = gender
    }
    
    func autoFormatBirth(_ input: String) -> String {
        BirthDateInputFormatter.autoFormat(input)
    }
    
    func saveButtonTapped() {
        let formattedBirthDay = birthDay.replacingOccurrences(of: "/", with: "-")
        
        let request = UpdateUserProfileRequest(
            name: nickname,
            birth: formattedBirthDay,
            gender: gender.serverValue
        )
        
        userAPIService.updateUserProfile(request: request) { result in
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
