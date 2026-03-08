//
//  LoginViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import AuthenticationServices

import KakaoSDKUser

class LoginViewModel: ObservableObject {
    private let authManager: AuthManager
    
    init(
         authManager: AuthManager = .shared) {
        self.authManager = authManager
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
               let identityTokenData = appleIDCredential.authorizationCode,
               let identityToken = String(data: identityTokenData, encoding: .utf8) {
                
                Task {
                    let deviceId = DeviceIDManager.shared.getDeviceId()
                    await authManager.loginWithApple(identityToken, deviceId: deviceId)
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    
    func loginWithKakao() {
        // 카카오톡 설치 여부
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                guard let oauthToken else { return }
                
                Task {
                    do {
                        let deviceId = DeviceIDManager.shared.getDeviceId()
                        let accessToken = oauthToken.accessToken
                        try await self?.authManager.loginWithKakao(accessToken, deviceId: deviceId)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            print("카카오앱이 설치되지 않음.")
        }
    }
}
