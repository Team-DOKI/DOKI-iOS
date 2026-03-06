//
//  ProfileAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

import Foundation
import Moya

protocol ProfileAPIServiceProtocol {
    /// 유저 및 반려견 정보 등록
    func register(request: UserProfileRequest, completion: @escaping (NetworkResult<RegisterResponseDTO>) -> Void)
    
    /// 견종 조회
    func fetchBreedList(completion: @escaping (NetworkResult<BreedListResponseDTO>) -> Void)
    
    /// 유저 정보 조회
    func fetchUserProfile(completion: @escaping (NetworkResult<UserProfileResponseDTO>) -> Void)
    
    /// 반려견 정보 조회
    func fetchPetProfile(petId: Int,completion: @escaping (NetworkResult<PetProfileResponseDTO>) -> Void)
    
    /// 유저 정보 수정
    func updateUserProfile(
        request: UpdateUserProfileRequest,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    )
    
    /// 반려견 프로필 수정
    func updatePetProfile(
        petId: Int,
        request: UpdatePetProfileRequest,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    )
    
    /// 닉네임 중복 검사
    func checkNicknameDuplicate(
        nickname: String,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    )
}

extension ProfileAPIServiceProtocol {
    typealias RegisterResponseDTO = BaseDTO<RegisterResponse>
    typealias BreedListResponseDTO = BaseDTO<BreedListResponse>
    typealias UserProfileResponseDTO = BaseDTO<UserProfileResponse>
    typealias PetProfileResponseDTO = BaseDTO<PetProfileResponse>
}

final class ProfileAPIService: BaseAPIService, ProfileAPIServiceProtocol {
    
    private let provider = MoyaProvider<ProfileAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 유저 및 반려견 정보 등록
    func register(request: UserProfileRequest, completion: @escaping (NetworkResult<RegisterResponseDTO>) -> Void) {
        self.request(.register(request: request),
                     provider: provider,
                     responseType: RegisterResponseDTO.self,
                     completion: completion)
    }
    
    /// 견종 조회
    func fetchBreedList(completion: @escaping (NetworkResult<BreedListResponseDTO>) -> Void) {
        self.request(.fetchBreedList,
                     provider: provider,
                     responseType: BreedListResponseDTO.self,
                     completion: completion)
    }
    
    /// 유저 정보 조회
    func fetchUserProfile(completion: @escaping (NetworkResult<UserProfileResponseDTO>) -> Void) {
        self.request(.fetchUserProfile,
                     provider: provider,
                     responseType: UserProfileResponseDTO.self,
                     completion: completion)
    }
    
    /// 반려견 정보 조회
    func fetchPetProfile(petId: Int, completion: @escaping (NetworkResult<PetProfileResponseDTO>) -> Void) {
        self.request(.fetchPetProfile(petId: petId),
                     provider: provider,
                     responseType: PetProfileResponseDTO.self,
                     completion: completion)
    }
    
    /// 유저 정보 수정
    func updateUserProfile(
        request: UpdateUserProfileRequest,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    ) {
        self.request(
            .updateUserProfile(request: request),
            provider: provider,
            responseType: BaseDTO<EmptyResponse>.self,
            completion: completion
        )
    }
    
    /// 반려견 프로필 수정
    func updatePetProfile(
        petId: Int,
        request: UpdatePetProfileRequest,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    ) {
        self.request(
            .updatePetProfile(petId: petId, request: request),
            provider: provider,
            responseType: BaseDTO<EmptyResponse>.self,
            completion: completion
        )
    }
    
    /// 닉네임 중복 검사
    func checkNicknameDuplicate(
        nickname: String,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    ) {
        self.request(
            .checkNicknameDuplicate(nickname: nickname),
            provider: provider,
            responseType: BaseDTO<EmptyResponse>.self,
            completion: completion
        )
    }
}
