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
}

extension UserAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .register, .fetchBreedList:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "users"
        case .fetchBreedList:
            return "pets/breeds"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        case .fetchBreedList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .register(request):
            return .requestJSONEncodable(request)
        case .fetchBreedList:
            return .requestPlain
        }
    }
}
