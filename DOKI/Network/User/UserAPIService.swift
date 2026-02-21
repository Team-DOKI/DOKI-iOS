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
    
    // MARK: - 공통 request
    
    private func request<T: Decodable>(
        _ target: UserAPI,
        completion: @escaping (NetworkResult<T>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }
            
            let networkResult: NetworkResult<T>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                } else {
                    networkResult = .networkFail
                }
            }
            
            completion(networkResult)
        }
    }
    
    // MARK: - API
    
    /// 유저 및 반려견 정보 등록
    func register(request: UserProfileRequest, completion: @escaping (NetworkResult<RegisterResponseDTO>) -> Void) {
        self.request(.register(request: request), completion: completion)
    }
    
    /// 견종 조회
    func fetchBreedList(completion: @escaping (NetworkResult<BreedListResponseDTO>) -> Void
    ) {
        self.request(.fetchBreedList, completion: completion)
    }
    
    /// 유저 정보 조회
    func fetchUserProfile(completion: @escaping (NetworkResult<UserProfileResponseDTO>) -> Void
    ) {
        self.request(.fetchUserProfile, completion: completion)
    }
    
    /// 반려견 정보 조회
    func fetchPetProfile(petId: Int, completion: @escaping (NetworkResult<PetProfileResponseDTO>) -> Void
    ) {
        self.request(.fetchPetProfile(petId: petId), completion: completion)
    }
}
