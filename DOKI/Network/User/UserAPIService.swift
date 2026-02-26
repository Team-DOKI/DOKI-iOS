//
//  UserAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//


import Foundation
import Moya

protocol UserAPIServiceProtocol {
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
}

extension UserAPIServiceProtocol {
    typealias RegisterResponseDTO = BaseDTO<RegisterResponse>
    typealias BreedListResponseDTO = BaseDTO<BreedListResponse>
    typealias UserProfileResponseDTO = BaseDTO<UserProfileResponse>
    typealias PetProfileResponseDTO = BaseDTO<PetProfileResponse>
}

final class UserAPIService: BaseAPIService, UserAPIServiceProtocol {
    
    private let provider = MoyaProvider<UserAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
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
}
