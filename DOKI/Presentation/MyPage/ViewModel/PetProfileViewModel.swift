//
//  PetProfileViewModel.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

class PetProfileViewModel: ObservableObject {
    private let userAPIService: UserAPIServiceProtocol
    private let imageAPIService: ImageAPIServiceProtocol
    
    init(
        userAPIService: UserAPIServiceProtocol = UserAPIService(),
        imageAPIService: ImageAPIServiceProtocol = ImageAPIService(),
        petProfile: PetProfileResponse
        
    ) {
        self.userAPIService = userAPIService
        self.imageAPIService = imageAPIService
        
        self.dogName = petProfile.name
        self.dogBirthDay = petProfile.birth.replacingOccurrences(of: "-", with: "/")
        self.dogGender = petProfile.gender == "남아" ? .male : .female
        self.selectedBreedName = petProfile.breed
        self.isNeutered = petProfile.isNeutered
        self.petProfileImageUrl = petProfile.imageUrl
    }
    
    // MARK: - Published Properties (Update Request DTO)
    
    @Published var dogName: String
    @Published var dogBirthDay: String
    @Published var dogGender: Gender
    @Published var isNeutered = false
    @Published var breedId: Int?
    @Published var imageId: Int?
    
    // MARK: - Published Properties (UI)
    
    @Published var petProfileImageUrl: String?
    @Published var newPetProfileImage: UIImage?
    
    @Published var breedList: [BreedList] = []
    @Published var selectedBreedName: String = ""
    @Published var breedSearchText = ""
    @Published var isShowBreedSearch = false
    
    func selectDogGender(_ gender: Gender) {
        self.dogGender = gender
    }
    
    func toggleIsNeutered() {
        isNeutered.toggle()
    }
    
    func toggleBreedSearchSheet() {
        isShowBreedSearch.toggle()
    }
    
    func selectBreed(_ breed: BreedList) {
        self.breedId = breed.id
        self.selectedBreedName = breed.name
    }
    
    func autoFormatBirth(_ input: String) -> String {
        BirthDateInputFormatter.autoFormat(input)
    }
}

// MARK: - API

extension PetProfileViewModel {
    /// 반려견 정보 수정
    func saveButtonTapped() {
        let formattedBirthDay = dogBirthDay.replacingOccurrences(of: "/", with: "-")
        
        //        let request = UpdatePetProfileRequest(
        //            name: dogName,
        //            birth: formattedBirthDay,
        //            gender: dogGender.serverValue,
        //            isNeutered: isNeutered,
        //            breedId: breedId,
        //            imageId: imageId
        //        )
        
        //        userAPIService.updatePetProfile(petId: petId, request: request) { result in
        //            switch result {
        //            case .success:
        //
        //            default:
        //                print("반려견 정보 수정에 실패했습니다.")
        //            }
        //        }
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
    
    /// Presigned URL 요청
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
                    else { return }
                    
                    self.uploadToS3(url: uploadUrl, data: imageData) { success in
                        if success {
                            self.registerImage(image: image, imageUrl: data.imageUrl)
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
    
    /// 이미지 등록
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
                        self.newPetProfileImage = image
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
