//
//  ProfileSetUpViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

final class ProfileSetUpViewModel: ObservableObject {
    
    enum ProfileStep: Int {
        case ownerInfo = 1
        case activityArea
        case dogInfo
        case dogTendency
        
        var navigationTitle: String {
            switch self {
            case .ownerInfo:
                "회원가입"
            case .activityArea:
                "회원가입"
            case .dogInfo:
                "반려견 등록하기"
            case .dogTendency:
                "반려견 등록하기"
            }
        }
    }
    
    @Published var profileStep: ProfileStep = .ownerInfo
    
    var step: Int { profileStep.rawValue }
    
    func goToNextStep() {
        profileStep = ProfileStep(rawValue: profileStep.rawValue + 1) ?? .dogTendency
    }
    
    func goToPrevStep() {
        profileStep = ProfileStep(rawValue: profileStep.rawValue - 1) ?? .ownerInfo
    }
}
