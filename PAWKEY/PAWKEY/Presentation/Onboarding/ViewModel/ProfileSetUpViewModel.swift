//
//  ProfileSetUpViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct UserProfile {
    var userName: String = ""
    var userGender: String = ""
    var userAge: String = ""
    var region: String = ""
    var legalRegion: String = ""
    var dogName: String = ""
    var dogGender: String = ""
    var energyLevel: String = ""
    var societyLevel: String = ""
    var knownDogAgeResult = ""
    var dogBreed: String = ""
    var isNeutered = false
}

enum ProfileField {
    case userName(String)
    case userGender(String)
    case userAge(String)
    case region(String)
    case legalRegion(String)
    case dogName(String)
    case dogGender(String)
    case KnownDogAge(String)
    case energyLevel(String)
    case societyLevel(String)
    case dogBreed(String)
    case neutered(Bool)
}

final class ProfileSetUpViewModel: ObservableObject {
    
    enum ProfileStep: Int {
        case ownerInfo = 1
        case activityArea
        case dogInfo
        case dogTendency
        
        var title: String {
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
    
    // 모델(임시)
    let genderList = ["남자", "여자"]
    let regionList = ["강남구"]
    let legalRegionList = [
        "개포동", "논현동", "대치동", "도곡동", "삼성동",
        "세곡동", "수서동", "신사동", "압구정동", "역삼동",
        "율현동", "자곡동", "청담동", "일원동"
    ]
    let dogGenderList = ["남아", "여아"]
    let knownDogAgeList = ["나이를 알아요", "나이를 몰라요"]
    let energyLevel = ["매우 차분해요", "조금 느긋해요", "활동적이에요", "아주 활발해요"]
    let societyLevel = ["잘 어울려요", "천천히 친해져요", "낯을 가려요", "상관없어요"]
        
    @Published var userProfile = UserProfile()
    @Published var currentStep: ProfileStep = .ownerInfo

    var currentStepIndex: Int { currentStep.rawValue }
    var isButtonDisabled: Bool {
        switch currentStep {
        case .ownerInfo:
            return userProfile.userName.isEmpty ||
            userProfile.userGender.isEmpty ||
            userProfile.userAge.isEmpty
            
        case .activityArea:
            return userProfile.region.isEmpty ||
            userProfile.legalRegion.isEmpty
            
        case .dogInfo:
            return userProfile.dogName.isEmpty ||
            userProfile.dogGender.isEmpty ||
            userProfile.dogBreed.isEmpty ||
            userProfile.knownDogAgeResult.isEmpty
            
        case .dogTendency:
            return userProfile.energyLevel.isEmpty ||
            userProfile.societyLevel.isEmpty
        }
    }
    
    func goToNextStep() {
        currentStep = ProfileStep(rawValue: currentStep.rawValue + 1) ?? .dogTendency
    }
    
    func goToPrevStep() {
        currentStep = ProfileStep(rawValue: currentStep.rawValue - 1) ?? .ownerInfo
    }
    
    func changeUserInfo(_ field: ProfileField) {
        switch field {
        case .userName(let name):
            userProfile.userName = name
        case .userGender(let gender):
            userProfile.userGender = gender
        case .userAge(let age):
            userProfile.userAge = age
        case .region(let region):
            userProfile.region = region
        case .legalRegion(let legal):
            userProfile.legalRegion = legal
        case .dogName(let name):
            userProfile.dogName = name
        case .dogGender(let gender):
            userProfile.dogGender = gender
        case .KnownDogAge(let knownDogAgeResult):
            userProfile.knownDogAgeResult = knownDogAgeResult
        case .energyLevel(let energyLevel):
            userProfile.energyLevel = energyLevel
        case .societyLevel(let societyLevel):
            userProfile.societyLevel = societyLevel
        case .dogBreed(let dogBreed):
            userProfile.dogBreed = dogBreed
        case .neutered(let neutered):
            userProfile.isNeutered = neutered
        }
    }
}
