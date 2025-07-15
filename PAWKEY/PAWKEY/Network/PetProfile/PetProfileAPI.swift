//
//  PetProfileAPI.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/15/25.
//

import Foundation

import Moya

enum PetProfileAPI {
    case getPetProfile
}

extension PetProfileAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getPetProfile:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .getPetProfile:
            return "users/me/pets"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPetProfile:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPetProfile:
            return .requestPlain
        }
    }
}
