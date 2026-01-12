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
    
    // MARK: - Published Properties
    
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
    @Published var regionList: [DistrictDTO] = [
        DistrictDTO(
            gu: Gu(id: 1, name: "강남구"),
            dongs: [
                Dong(id: 101, name: "역삼동"),
                Dong(id: 102, name: "삼성동"),
                Dong(id: 103, name: "논현동"),
                Dong(id: 104, name: "청담동")
            ]
        ),
        DistrictDTO(
            gu: Gu(id: 2, name: "송파구"),
            dongs: [
                Dong(id: 201, name: "잠실동"),
                Dong(id: 202, name: "방이동"),
                Dong(id: 203, name: "풍납동"),
                Dong(id: 204, name: "가락동")
            ]
        ),
        DistrictDTO(
            gu: Gu(id: 3, name: "마포구"),
            dongs: [
                Dong(id: 301, name: "합정동"),
                Dong(id: 302, name: "상수동"),
                Dong(id: 303, name: "망원동"),
                Dong(id: 304, name: "서교동"),
                Dong(id: 305, name: "연남동")
            ]
        ),
        DistrictDTO(
            gu: Gu(id: 4, name: "용산구"),
            dongs: [
                Dong(id: 401, name: "이태원동"),
                Dong(id: 402, name: "한남동"),
                Dong(id: 403, name: "후암동"),
                Dong(id: 404, name: "효창동"),
                Dong(id: 405, name: "용문동")
            ]
        ),
        DistrictDTO(
            gu: Gu(id: 5, name: "종로구"),
            dongs: [
                Dong(id: 501, name: "청운동"),
                Dong(id: 502, name: "부암동"),
                Dong(id: 503, name: "평창동"),
                Dong(id: 504, name: "삼청동"),
                Dong(id: 505, name: "혜화동")
            ]
        )
    ]
    @Published var breedList: [String] = [
        "말티즈",
        "포메라니안",
        "푸들",
        "시츄",
        "치와와",
        "골든 리트리버",
        "래브라도 리트리버",
        "시베리안 허스키",
        "요크셔 테리어",
        "보더콜리"
    ]
    @Published var breedSearchText = ""
    @Published var areaSearchText = ""
    @Published var isShowMapView = false
    
    // MARK: - Computed Properties
    
    var next: UserInfoStep? { UserInfoStep(rawValue: currentStep.rawValue + 1) }
    var prev: UserInfoStep? { UserInfoStep(rawValue: currentStep.rawValue - 1) }
    var buttonDisabled: Bool {
        switch currentStep {
        case .userProfile: nickname.isEmpty || birthDay.isEmpty || gender == nil
        case .dogProfile: dogName.isEmpty || dogBirthDay.isEmpty || dogGender == nil || breed.isEmpty
        case .activityArea: selectedGuId == nil || selectedDongId == nil
        }
    }
    var isLastStep: Bool { next == nil }
    var isFirstStep: Bool { prev == nil }
    
    // MARK: - User Action
    
    func goToNextStep() {
        if let next { currentStep = next }
    }
    
    func goToPrevStep() {
        if let prev { currentStep = prev }        
    }
    
    func selecteGender(_ gender: Gender) {
        self.gender = gender
    }
    
    func selectDogGender(_ gender: Gender) {
        self.dogGender = gender
    }
    
    func toggleIsNeutering() {
        isNeutering.toggle()
    }
    
    func toggleBreedSearchSheet() {
        isShowBreedSearch.toggle()
    }
    
    func selectBreed(_ breed: String) {
        self.breed = breed
    }
    
    func selectGuID(_ id: Int) {
        selectedGuId = id
    }
    
    func toggleActivityArea() {
        isShowActivityArea.toggle()
    }
    
    func seletDongId(_ id: Int) {
        selectedDongId = id
    }
    
    func selectActivityArea() {
        guard let guId = selectedGuId,
              let dongId = selectedDongId,
              let district = regionList.first(where: {$0.gu.id == guId}),
              let dong = district.dongs.first(where: {$0.id == dongId }) else {
            regionDisplayName = ""
            return
        }
        regionDisplayName = "\(district.gu.name) \(dong.name)"
        isShowMapView = false
    }
}
