//
//  LoginAPI.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

import Moya

enum LoginAPI {
    case appleLogin(appleLoginReqDto: AppleLoginRequestDTO)    
}

extension LoginAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .appleLogin:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .appleLogin:
            return "auth/apple/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .appleLogin(appleLoginReqDto):
            return .requestJSONEncodable(appleLoginReqDto)
        }
    }
}
