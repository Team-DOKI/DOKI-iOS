//
//  MyProfileViewModel.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

class MyProfileViewModel: ObservableObject {
    @Published var nickname: String
    @Published var birthDay: String
    @Published var gender: Gender
    
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
    
    func selecteGender(_ gender: Gender) {
        self.gender = gender
    }
    
    func autoFormatBirth(_ input: String) -> String {
        BirthDateInputFormatter.autoFormat(input)
    }
    
    func saveButtonTapped() {
        
    }
}
