//
//  RegisterViewModel.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI
import Moya

final class RegisterViewModel: ObservableObject {
    private let userAPIService: UserAPIServiceProtocol
    private let imageAPIService: ImageAPIServiceProtocol
    private let regionAPIService: RegionAPIServiceProtocol
    
    init(
        userAPIService: UserAPIServiceProtocol = UserAPIService(),
        imageAPIService: ImageAPIServiceProtocol = ImageAPIService(),
        regionAPIService: RegionAPIServiceProtocol = RegionAPIService()
    ) {
        self.userAPIService = userAPIService
        self.imageAPIService = imageAPIService
        self.regionAPIService = regionAPIService
    }
    
    // MARK: - Published Properties (Register Request DTO)
    
    @Published var nickname = ""
    @Published var birthDay = ""
    @Published var gender: Gender?
    @Published var selectedDongId: Int?
    @Published var dogName = ""
    @Published var dogGender: Gender?
    @Published var dogBirthDay = ""
    @Published var isNeutered = false
    @Published var breedId: Int?
    @Published var imageId: Int?
    
    // MARK: - Published Properties (UI)
    
    @Published var petProfileImage: UIImage?
    
    @Published var breedList: [BreedList] = []
    @Published var selectedBreedName: String = ""
    @Published var breedSearchText = ""
    @Published var isShowBreedSearch = false
    
    @Published var regionList: [DistrictDTOs] = []
    @Published var selectedGuId: Int?
    @Published var previewRegionName: String = ""
    @Published var selectedRegionName = ""
    @Published var areaSearchText = ""
    
    // MARK: - Step
    
    @Published var currentStep: UserInfoStep = .userProfile
    @Published var regionFlow: RegionFlow = .none
    
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
    
    var next: UserInfoStep? { UserInfoStep(rawValue: currentStep.rawValue + 1) }
    var prev: UserInfoStep? { UserInfoStep(rawValue: currentStep.rawValue - 1) }
    var buttonDisabled: Bool {
        switch currentStep {
        case .userProfile: nickname.isEmpty || birthDay.isEmpty || gender == nil
        case .dogProfile: dogName.isEmpty || dogBirthDay.isEmpty || dogGender == nil || breedId == nil
        case .activityArea: selectedGuId == nil || selectedDongId == nil
        }
    }
    var isLastStep: Bool { next == nil }
    var isFirstStep: Bool { prev == nil }
    
    enum RegionFlow {
        case none
        case search
        case map
    }
    
    // MARK: - User Action
    
    var filteredBreeds: [BreedList] {
        if breedSearchText.isEmpty {
            return breedList
        } else {
            return breedList.filter {
                $0.name.localizedCaseInsensitiveContains(breedSearchText)
            }
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
    
    func selectDogGender(_ gender: Gender) {
        self.dogGender = gender
    }
    
    func toggleIsNeutered() {
        isNeutered.toggle()
    }
    
    func toggleBreedSearchSheet() {
        isShowBreedSearch.toggle()
    }
    
    func selectBreed(_ breedList: BreedList) {
        breedId = breedList.id
        selectedBreedName = breedList.name
    }
    
    func selectGuID(_ id: Int) {
        selectedGuId = id
        selectedDongId = nil
    }
    
    func seletDongId(_ id: Int) {
        selectedDongId = id
        
        guard let guId = selectedGuId,
              let region = regionList.first(where: { $0.gu.id == guId }),
              let dong = region.dongs.first(where: { $0.id == id })
        else { return }
        
        previewRegionName = "\(region.gu.name) \(dong.name)"
        regionFlow = .map
    }
    
    func selectRegion() {
        selectedRegionName = previewRegionName
    }
    
    func resetRegionSelection() {
        selectedGuId = nil
        selectedDongId = nil
        previewRegionName = ""
        selectedRegionName = ""
    }
    
    func autoFormatBirth(_ input: String) -> String {
        BirthDateInputFormatter.autoFormat(input)
    }
}

// MARK: - API (유저 및 반려견 정보)

extension RegisterViewModel {
    /// 유저 및 반려견 정보 등록
    func registerUser() {
        guard
            let gender,
            let dogGender,
            let breedId,
            let imageId,
            let selectedDongId
        else { return }
        
        let formattedBirthDay = birthDay.replacingOccurrences(of: "/", with: "-")
        let formattedDogBirthDay = dogBirthDay.replacingOccurrences(of: "/", with: "-")
        
        let request = UserProfileRequest(
            name: nickname,
            birth: formattedBirthDay,
            gender: gender.serverValue,
            dongId: selectedDongId,
            pet: PetProfileRequest(
                name: dogName,
                gender: dogGender.serverValue,
                birth: formattedDogBirthDay,
                isNeutered: isNeutered,
                breedId: breedId,
                imageId: imageId
            )
        )
        
        userAPIService.register(request: request) { result in
            switch result {
            case .success(let response):
                guard
                    let userId = response?.data?.userId,
                    let petId  = response?.data?.petId
                else { return }
                
                // TODO: petId 관리 (반려견 정보 조회 등에서 사용)
            default:
                print("회원가입 정보를 불러오지 못했습니다.")
            }
        }
    }
    
    /// 견종 조회
    func fetchBreedList() {
        userAPIService.fetchBreedList { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.breedList = response?.data?.breedList ?? []
                default:
                    print("견종 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    /// 지역구 조회
    func fetchRegions() {
        regionAPIService.fetchRegions { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.regionList = response?.data?.districtDtos ?? []
                    
                default:
                    print("지역 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
}

// MARK: - API (이미지 등록)

extension RegisterViewModel {
    func uploadDogImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let presignedRequest = PresignedUrlRequest(
            domain: "PET_PROFILE",
            contentType: "image/jpeg"
        )
        
        imageAPIService.fetchPresignedURL(request: presignedRequest) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard
                        let data = response?.data,
                        let uploadUrl = URL(string: data.uploadUrl)
                    else {
                        print("Presigned URL 파싱 실패")
                        return
                    }
                    
                    self.uploadToS3(url: uploadUrl, data: imageData) { success in
                        if success {
                            self.registerImage(
                                image: image,
                                imageUrl: data.imageUrl
                            )
                        } else {
                            print("S3 업로드 실패")
                        }
                    }
                    
                default:
                    print("Presigned URL 요청 실패")
                }
            }
        }
    }
    
    private func registerImage(image: UIImage, imageUrl: String) {
        let request = RegisterImageRequest(
            imageUrl: imageUrl,
            contentType: "image/jpeg",
            width: Int(image.size.width),
            height: Int(image.size.height),
            domain: "PET_PROFILE"
        )
        
        imageAPIService.registerImage(request: request) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let imageId = response?.data?.imageId {
                        self.imageId = imageId
                        self.petProfileImage = image
                        print("이미지 업로드 성공, imageId:", imageId)
                    }
                default:
                    print("이미지 등록 실패")
                }
            }
        }
    }
    
    private func uploadToS3(url: URL, data: Data, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse,
               200..<300 ~= httpResponse.statusCode {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
