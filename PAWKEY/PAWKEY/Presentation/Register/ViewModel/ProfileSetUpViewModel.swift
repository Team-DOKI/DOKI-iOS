//
//  ProfileSetUpViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI
import Moya

enum KnownDogAge: String, CaseIterable, Hashable {
    case known = "나이를 알아요"
    case unknown = "나이를 몰라요"
}

enum ProfileField {
    case userName(String)
    case userGender(String)
    case userAge(String)
    case region(String)
    case legalRegion(String)
    case dogName(String)
    case dogGender(String)
    case KnownDogAge(KnownDogAge?)
    case petTraits(categoryId: Int, optionId: Int)
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
    
    private let provider = MoyaProvider<PetTraitsCategoryAPI>()
    
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
    
    @Published var userProfile = UserProfile()
    @Published var currentStep: ProfileStep = .ownerInfo
    @Published var isKeyboardVisible = false
    
    @Published var petTraitsCategories: [PetTraitCategory] = []
    @Published var errorMessage: String?
    
    var currentStepIndex: Int { currentStep.rawValue }
    var isButtonDisabled: Bool {
        switch currentStep {
        case .ownerInfo:
            return userProfile.name.isEmpty ||
            userProfile.gender.isEmpty ||
            userProfile.age.isEmpty
            
        case .activityArea:
            return userProfile.regionId.isEmpty ||
            userProfile.legalRegion.isEmpty
            
        case .dogInfo:
            return userProfile.dogName.isEmpty ||
            userProfile.dogGender.isEmpty ||
            userProfile.breed.isEmpty ||
            userProfile.knownDogAge == .none ||
            (userProfile.isKnownAge && userProfile.dogAge.isEmpty)
            
        case .dogTendency:
            return petTraitsCategories.count != userProfile.petTraits.flatMap { $0.categoryOptions }.filter {$0.isSelected}.count
        }
    }
    
    // MARK: - State Method
    
    func goToNextStep() {
        currentStep = ProfileStep(rawValue: currentStep.rawValue + 1) ?? .dogTendency
    }
    
    func goToPrevStep() {
        currentStep = ProfileStep(rawValue: currentStep.rawValue - 1) ?? .ownerInfo
    }
    
    func changeUserInfo(_ field: ProfileField) {
        switch field {
        case .userName(let name):
            userProfile.name = name
        case .userGender(let gender):
            userProfile.gender = gender
        case .userAge(let age):
            userProfile.age = age
        case .region(let region):
            userProfile.regionId = region
        case .legalRegion(let legal):
            userProfile.legalRegion = legal
        case .dogName(let name):
            userProfile.dogName = name
        case .dogGender(let gender):
            userProfile.dogGender = gender
        case .KnownDogAge(let knownDogAge):
            userProfile.knownDogAge = knownDogAge
        case .petTraits(let categoryId, let optionId):
            // 선택한 카테고리 초기화
            guard let selectedCategoryId = userProfile.petTraits.firstIndex(where: {$0.categoryId == categoryId }),
                  let optionId = userProfile.petTraits[selectedCategoryId].categoryOptions.firstIndex(where: {$0.categoryOptionId == optionId}) else { return }
            
            userProfile.petTraits[selectedCategoryId].categoryOptions = petTraitsCategories[selectedCategoryId].categoryOptions
            userProfile.petTraits[selectedCategoryId].categoryOptions[optionId].isSelected.toggle()
            
        case .dogBreed(let dogBreed):
            userProfile.breed = dogBreed
        case .neutered(let neutered):
            userProfile.isNeutered = neutered
        }
    }
    
    // MARK: - API
    
    @MainActor
    func fetchPetTraitsCategories() async {
        do {
            let response: BaseDTO<PetTraitDTO> = try await provider.async.request(.fetchPetTraitsCategories)
            
            guard let data = response.data else {
                errorMessage = "에러 발생: 데이터를 찾을 수 없음"
                return
            }
            
            self.petTraitsCategories = data.petTraitCategoryList.map {$0.toEntity()}
            self.userProfile.petTraits = data.petTraitCategoryList.map {$0.toEntity()}
        } catch {
            errorMessage = "에러 발생: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func updateUserProfile() async {
        let provider = MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])
        
        do {
            let response: BaseDTO<PetTraitDTO> = try await provider.async.request(.updateUserProfile(userProfile))
            
            guard let data = response.data else {
                errorMessage = "에러 발생: 데이터를 찾을 수 없음"
                return
            }
                    
        } catch {
            errorMessage = "에러 발생: \(error.localizedDescription)"
        }
    }
}
