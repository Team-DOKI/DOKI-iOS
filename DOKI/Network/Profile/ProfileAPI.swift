//
//  ProfileAPI.swift
//  DOKI
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

import Moya

enum ProfileAPI {
    case register(request: UserProfileRequest) // 유저 및 반려견 정보 등록
    
    case fetchBreedList // 견종 조회
    case fetchUserProfile // 유저 정보 조회
    case fetchPetProfile(petId: Int) // 반려견 정보 조회
    
    case updateUserProfile(request: UpdateUserProfileRequest) // 유저 정보 수정
    case updatePetProfile(petId: Int, request: UpdatePetProfileRequest) // 반려견 프로필 수정
}

extension ProfileAPI: BaseTargetType {
    var headerType: HeaderType {
        .defaultHeader
    }
    
    var path: String {
        switch self {
        case .register, .updateUserProfile:
            return "users"
        case .fetchBreedList:
            return "pets/breeds"
        case .fetchUserProfile:
            return "users/me/userInfo"
        case let .fetchPetProfile(petId):
            return "pets/\(petId)"
        case let .updatePetProfile(petId, _):
            return "pets/\(petId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        case .fetchBreedList, .fetchUserProfile, .fetchPetProfile:
            return .get
        case .updateUserProfile, .updatePetProfile:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case let .register(request):
            return .requestJSONEncodable(request)
        case let .updateUserProfile(request):
            return .requestJSONEncodable(request)
        case let .updatePetProfile(_, request):
            return .requestJSONEncodable(request)
        case .fetchBreedList, .fetchUserProfile, .fetchPetProfile:
            return .requestPlain
        }
    }
}
