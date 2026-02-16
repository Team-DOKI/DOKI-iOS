//
//  RegisterViewModel.swift
//  DOKI
//
//  Created by a on 10/31/25.
//

import SwiftUI
import Moya

final class RegisterViewModel: ObservableObject {
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
    
    private let provider = MoyaProvider<UserAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    @Published var currentStep: UserInfoStep = .userProfile
    
    // MARK: - RegisterRequestDTO
    
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
    
    // MARK: - UI
    
    @Published var breedList: [BreedDTO] = []
    @Published var selectedBreedName: String = ""
    @Published var breedSearchText = ""
    
    @Published var profileImage: [UIImage] = []
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
    
    // MARK: - Computed Properties
    
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
    
    var filteredBreeds: [BreedDTO] {
        if breedSearchText.isEmpty {
            return breedList
        } else {
            return breedList.filter {
                $0.name.localizedCaseInsensitiveContains(breedSearchText)
            }
        }
    }
    
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
    
    func toggleIsNeutered() {
        isNeutered.toggle()
    }
    
    func toggleBreedSearchSheet() {
        isShowBreedSearch.toggle()
    }
    
    func selectBreed(_ breedList: BreedDTO) {
        breedId = breedList.id
        selectedBreedName = breedList.name
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

// MARK: - API (유저 및 반려견 정보)

extension RegisterViewModel {
    
    // 회원가입
    func registerUser() {
        guard
            let gender,
            let dogGender,
            let breedId,
            let imageId
        else {
            return
        }
        
        let formattedBirthDay = birthDay.replacingOccurrences(of: "/", with: "-")
        let formattedDogBirthDay = dogBirthDay.replacingOccurrences(of: "/", with: "-")
        
        let request = UserProfileDTO(
            name: nickname,
            birth: formattedBirthDay,
            gender: gender.serverValue,
            dongId: 3, // 수정 예정
            pet: PetProfileDTO(
                name: dogName,
                gender: dogGender.serverValue,
                birth: formattedDogBirthDay,
                isNeutered: isNeutered,
                breedId: breedId,
                imageId: imageId
            )
        )
        
        provider.request(.register(request: request)) { result in
            switch result {
            case .success(let response):
                print("회원가입 성공")
                print("statusCode:", response.statusCode)
            case .failure(let error):
                print("회원가입 실패")
                print(error.localizedDescription)
            }
        }
    }
    
    // 견종 조회
    func fetchBreedList() {
        provider.request(.fetchBreedList) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder()
                        .decode(BaseDTO<BreedListResponseDTO>.self, from: response.data)
                    
                    self.breedList = decoded.data?.breedList ?? []
                } catch {
                    print("견종 디코딩 실패:", error)
                }
                
            case .failure(let error):
                print("견종 조회 실패:", error.localizedDescription)
            }
        }
    }
}

// MARK: - API (이미지 등록)

extension RegisterViewModel {
    func uploadDogImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let imageProvider = MoyaProvider<ImageAPI>(
            session: MoyaSession.shared,
            plugins: [MoyaLoggingPlugin()]
        )
        
        let presignedRequest = PresignedUrlRequestDTO(
            domain: "PET_PROFILE",
            contentType: "image/jpeg"
        )
        
        imageProvider.request(.presigned(request: presignedRequest)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(BaseDTO<PresignedUrlResponseDTO>.self, from: response.data)
                    guard let presignedUrlString = decoded.data?.uploadUrl,
                          let imageUrl = decoded.data?.imageUrl,
                          let presignedUrl = URL(string: presignedUrlString) else {
                        print("Presigned URL parsing 실패")
                        return
                    }
                    
                    self.uploadToS3(url: presignedUrl, data: imageData) { success in
                        if success {
                            let registerRequest = RegisterImageRequestDTO(
                                imageUrl: imageUrl,
                                contentType: "image/jpeg",
                                width: Int(image.size.width),
                                height: Int(image.size.height),
                                domain: "PET_PROFILE"
                            )
                            
                            imageProvider.request(.register(request: registerRequest)) { result in
                                switch result {
                                case .success(let response):
                                    do {
                                        let decodedImage = try JSONDecoder().decode(BaseDTO<RegisterImageResponseDTO>.self, from: response.data)
                                        DispatchQueue.main.async {
                                            if let imageId = decodedImage.data?.imageId {
                                                self.imageId = imageId
                                                self.profileImage.append(image)
                                                print("이미지 업로드 성공, ImageId: \(imageId)")
                                            }
                                        }
                                    } catch {
                                        print("이미지 등록 디코딩 실패:", error)
                                    }
                                case .failure(let error):
                                    print("이미지 등록 실패:", error.localizedDescription)
                                }
                            }
                            
                        } else {
                            print("S3 업로드 실패")
                        }
                    }
                    
                } catch {
                    print("Presigned URL 디코딩 실패:", error)
                }
                
            case .failure(let error):
                print("Presigned URL 요청 실패:", error.localizedDescription)
            }
        }
    }
    
    private func uploadToS3(url: URL, data: Data, completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse,
               200..<300 ~= httpResponse.statusCode {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
