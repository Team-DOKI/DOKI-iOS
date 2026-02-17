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
    
    init(
        userAPIService: UserAPIServiceProtocol = UserAPIService(),
        imageAPIService: ImageAPIServiceProtocol = ImageAPIService()
    ) {
        self.userAPIService = userAPIService
        self.imageAPIService = imageAPIService
    }
    
    // MARK: - Published Properties (DTO)
    
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
    
    @Published var isShowActivityArea = false
    @Published var selectedGuId: Int?
    
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
    
    @Published var areaSearchText = ""
    @Published var isShowMapView = false
    
    // MARK: - Step
    
    @Published var currentStep: UserInfoStep = .userProfile
    
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
    }
    
    func seletDongId(_ id: Int) {
        selectedDongId = id
    }
    
    func toggleActivityArea() {
        isShowActivityArea.toggle()
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

// MARK: - API (유저 및 반려견 정보)

extension RegisterViewModel {
    /// 유저 및 반려견 정보 등록
    func registerUser() {
        guard
            let gender,
            let dogGender,
            let breedId,
            let imageId
        else { return }
        
        let formattedBirthDay = birthDay.replacingOccurrences(of: "/", with: "-")
        let formattedDogBirthDay = dogBirthDay.replacingOccurrences(of: "/", with: "-")
        
        let request = UserProfileRequest(
            name: nickname,
            birth: formattedBirthDay,
            gender: gender.serverValue,
            dongId: 3,
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
                if let petId = response?.data?.petId {
                    UserDefaults.standard.set(petId, forKey: "petId")
                }
                
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
