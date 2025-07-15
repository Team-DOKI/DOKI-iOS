//
//  ProfileSetUpViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI
import Moya

struct UserProfile {
    var userName: String = ""
    var userGender: String = ""
    var userAge: String = ""
    var regionId: Int = 0
    var dogName: String = ""
    var dogAge: String = ""
    var dogGender: String = ""
    var petTraits: [PetTraitCategory] = []
    var knownDogAge: KnownDogAge?
    var dogBreed: String = ""
    var isNeutered = false
    
    var isKnownAge: Bool {
        knownDogAge == .known
    }
}

enum KnownDogAge: String, CaseIterable, Hashable {
    case known = "나이를 알아요"
    case unknown = "나이를 몰라요"
}

enum ProfileField {
    case userName(String)
    case userGender(String)
    case userAge(String)
    case region(Int)
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
            case .ownerInfo: "회원가입"
            case .activityArea: "회원가입"
            case .dogInfo: "반려견 등록하기"
            case .dogTendency: "반려견 등록하기"
            }
        }
    }
    
    // 모델(임시)
    let genderList = ["남자", "여자"]
    let dogGenderList = ["남아", "여아"]
    let knownDogAgeList = ["나이를 알아요", "나이를 몰라요"]
    
    // View state
    @Published var currentStep: ProfileStep = .ownerInfo
    @Published var isKeyboardVisible = false
    
    // User state
    @Published var userProfile = UserProfile()
    @Published var petTraitsCategories: [PetTraitCategory] = []
    @Published var regions: [RegionUnit] = []
    @Published var selectedRegiondId: Int?
    
    @Published var errorMessage: String?
    
    var selectedLegalRegions: [Area]? {
        regions.first(where: {$0.gu.id == selectedRegiondId })?.dong
    }
    var currentStepIndex: Int { currentStep.rawValue }
    var isButtonDisabled: Bool {
        switch currentStep {
        case .ownerInfo:
            return userProfile.userName.isEmpty ||
            userProfile.userGender.isEmpty ||
            userProfile.userAge.isEmpty
            
        case .activityArea:
            return userProfile.regionId == 0
            
        case .dogInfo:
            return userProfile.dogName.isEmpty ||
            userProfile.dogGender.isEmpty ||
            userProfile.dogBreed.isEmpty ||
            userProfile.knownDogAge == .none ||
            (userProfile.isKnownAge && userProfile.dogAge.isEmpty)
        case .dogTendency:
            return petTraitsCategories.count != userProfile.petTraits.flatMap { $0.categoryOptions }.filter {$0.isSelected}.count
        }
    }
}

// MARK: - State Method

extension ProfileSetUpViewModel {
    
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
        case .region(let regionId):
            userProfile.regionId = regionId
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
            userProfile.dogBreed = dogBreed
        case .neutered(let neutered):
            userProfile.isNeutered = neutered
        }
    }
    
    func selecteRegion(_ regionId: Int) {
        selectedRegiondId = regionId
    }
}

// MARK: - API

extension ProfileSetUpViewModel {
    
    @MainActor
    func fetchPetTraitsCategories() async {
        let provider = MoyaProvider<PetTraitsCategoryAPI>()
        
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
    func fetchRegions() async {
        let provider = MoyaProvider<RegionAPI>()
        
        do {
            let response: BaseDTO<DistrictDTO> = try await provider.async.request(.fetchRegions)
            
            guard let data = response.data else {
                errorMessage = "에러 발생: 데이터를 찾을 수 없음"
                return
            }
            
            self.regions = data.districtDtos.toEntity()
            
        } catch {
            errorMessage = "에러 발생: \(error.localizedDescription)"
        }
    }
}
