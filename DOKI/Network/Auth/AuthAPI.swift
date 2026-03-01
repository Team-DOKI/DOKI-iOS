//
//  LoginAPI.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

import Moya

enum AuthAPI {
    case appleLogin(request: AppleLoginRequest) // 애플 로그인
    case logout(request: LogoutRequest) // 로그아웃
    case withdraw(request: WithdrawRequest) // 탈퇴
    case refreshToken(request: RefreshTokenRequest) // 토큰 재발급
}

extension AuthAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
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
