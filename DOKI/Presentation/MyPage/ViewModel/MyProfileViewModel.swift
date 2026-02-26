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
    
    func formatBirthDate(_ input: String) -> String {
        let numbersOnly = input.filter { $0.isNumber }
        let limited = String(numbersOnly.prefix(8))
        
        let count = limited.count
        
        switch count {
        case 0...3:
            return limited
            
        case 4:
            return limited + "/"
            
        case 5:
            let year = limited.prefix(4)
            let month = limited.suffix(1)
            return "\(year)/\(month)"
            
        case 6:
            let year = limited.prefix(4)
            let month = limited.dropFirst(4)
            return "\(year)/\(month)/"
            
        default:
            let year = limited.prefix(4)
            let month = limited.dropFirst(4).prefix(2)
            let day = limited.dropFirst(6)
            return "\(year)/\(month)/\(day)"
        }
    }
    
    func saveButtonTapped() {
        
    }
}
