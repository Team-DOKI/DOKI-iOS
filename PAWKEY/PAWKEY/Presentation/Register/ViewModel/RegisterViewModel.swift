//
//  RegisterViewModel.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    enum UserInfoStep: Int {
        case userProfile
        case dogProfile
        case activityArea
        
        var navTitle: String {
            switch self {
            case .userProfile: "내 정보 입력"
            case .dogProfile: "반려견 정보 입력"
            case .activityArea: "산책 지역 입력"
            }
        }
    }
    
    @Published var currentStep: UserInfoStep = .userProfile
    @Published var nickname = ""
    @Published var birthDay = ""
    @Published var gender: Gender?
    @Published var dogName = ""
    @Published var dogBirthDay = ""
    @Published var dogGender: Gender?
    @Published var breed = ""
    @Published var isNeutering = false
    @Published var profileImage: [UIImage] = []
    @Published var isShowBreedSearch = false
    @Published var isShowActivityArea = false
    @Published var selectedGuId: Int?
    @Published var selectedDongId: Int?
    @Published var regionDisplayName = ""
    @Published var regionList: [String] = []
    @Published var breedList: [String] = []
    @Published var breedSearchText = ""
    @Published var areaSearchText = ""
    @Published var isShowMapView = false
    
    var next: UserInfoStep? { UserInfoStep(rawValue: currentStep.rawValue + 1) }
    var prev: UserInfoStep? { UserInfoStep(rawValue: currentStep.rawValue - 1) }
    var buttonDisabled: Bool {
        switch currentStep {
        case .userProfile: nickname.isEmpty || birthDay.isEmpty || gender == nil
        case .dogProfile: dogName.isEmpty || dogBirthDay.isEmpty || dogGender == nil || breed.isEmpty
        case .activityArea: selectedGuId == nil || selectedDongId == nil
        }
    }
    
    func goToNextStep() {
        if let next { currentStep = next }
    }
    
    func goToPrevStep() {
        if let prev { currentStep = prev }
    }
    
    func selecteGender(_ gender: Gender) {
        self.gender = gender
    }
}
