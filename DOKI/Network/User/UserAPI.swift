//
//  UserAPI.swift
//  DOKI
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

import Moya

enum UserAPI {
    case register(request: UserProfileDTO)
    case fetchBreedList
    case fetchUserProfile
    case fetchPetProfile(petId: Int)
}

extension UserAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .register, .fetchBreedList, .fetchUserProfile, .fetchPetProfile:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "users"
        case .fetchBreedList:
            return "pets/breeds"
        case .fetchUserProfile:
            return "users/me/userInfo"
        case let .fetchPetProfile(petId):
                return "pets/\(petId)"
            }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        case .fetchBreedList, .fetchUserProfile, .fetchPetProfile:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .register(request):
            return .requestJSONEncodable(request)
        case .fetchBreedList, .fetchUserProfile, .fetchPetProfile:
            return .requestPlain
        }
    }
}
