//
//  LoginViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI
import AuthenticationServices

class LoginViewModel: ObservableObject {
    private let loginCoordinator: Coordinator<LoginRoute>
    
    init(loginCoordinator: Coordinator<LoginRoute>) {
        self.loginCoordinator = loginCoordinator
    }
    
    /// 유저정보 등록화면으로 이동
    func navigateToRegister() {
        loginCoordinator.push(.register)
    }
    
    /// Apple 로그인 요청
    func requestAppleLogin(_ request :ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    // Apple 로그인 완료
    func onCompleteAppleLogin(_: Result<ASAuthorization, any Error>) {
        
    }
}
