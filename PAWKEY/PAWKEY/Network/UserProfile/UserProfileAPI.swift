//
//  UserProfileAPI.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//


import Foundation

import Moya

enum UserProfileAPI {
    case getUserProfile
}

extension UserProfileAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getUserProfile:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .getUserProfile:
            return "users/me/userInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserProfile:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserProfile:
            return .requestPlain
        }
    }
}
