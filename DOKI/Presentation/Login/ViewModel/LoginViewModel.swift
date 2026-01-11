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
    private let authManager: AuthManager
    
    init(loginCoordinator: Coordinator<LoginRoute>,
         authManager: AuthManager = .shared) {
        self.loginCoordinator = loginCoordinator
        self.authManager = authManager
    }
    
    /// 유저정보 등록화면으로 이동
    func navigateToRegister() {
        loginCoordinator.push(.register)
    }
    
    /// Apple 로그인 요청
    func requestAppleLogin(_ request :ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    /// Apple 로그인 요청 완료
    func onCompleteAppleLogin(_ result: Result<ASAuthorization, any Error>) {
        switch result {
        case .success(let authResult):
            if let appleIDCredential = authResult.credential as? ASAuthorizationAppleIDCredential,
               let identityTokenData = appleIDCredential.identityToken,
               let identityToken = String(data: identityTokenData, encoding: .utf8) {
                Task {                    
                    await authManager.loginWithApple(identityToken, deviceId: "doki-service")
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
