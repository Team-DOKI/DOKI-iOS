//
//  LoginAPI.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

import Moya

enum AuthAPI {
    case appleLogin(request: AppleLoginRequestDTO)
    case logout(request: LogoutRequestDTO)
    case withdraw(request: WithdrawRequestDTO)
}

extension AuthAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .appleLogin, .logout, .withdraw:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .appleLogin:
            return "auth/apple/login"
        case .logout:
            return "auth/logout"
        case .withdraw:
            return "auth/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin, .logout:
            return .post
        case .withdraw:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case let .appleLogin(request):
            return .requestJSONEncodable(request)
            
        case let .logout(request):
            return .requestJSONEncodable(request)
            
        case let .withdraw(request):
            return .requestJSONEncodable(request)
        }
    }
}
