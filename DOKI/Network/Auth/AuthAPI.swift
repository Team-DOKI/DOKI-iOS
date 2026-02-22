//
//  LoginAPI.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

import Moya

enum AuthAPI {
    case appleLogin(request: AppleLoginRequest)
    case logout(request: LogoutRequest)
    case withdraw(request: WithdrawRequest)
    case refreshToken(request: TokenRefreshRequest)
}

extension AuthAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .appleLogin, .logout, .withdraw, .refreshToken:
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
        case .refreshToken:
            return "auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin, .logout, .refreshToken:
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
            
        case let .refreshToken(request):
            return .requestJSONEncodable(request)
        }
    }
}
