//
//  AuthManager.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

import Moya

enum AuthState: String, CaseIterable {
    case loggedIn
    case loggedOut
    case loading
}

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var authStatus: AuthState = .loading
    @Published var isNewUser: Bool = false
    
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    
    private let provider = MoyaProvider<AuthAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    private init() {}
    
    func checkLogin() {
        do {
            self.accessToken = try KeychainManager.read(.accessToken)
            self.refreshToken = try KeychainManager.read(.refreshToken)
            
            authStatus = .loggedIn
        } catch {
            authStatus = .loggedOut
            print(error.localizedDescription)
        }
    }
    
    /// 애플 로그인 API
    func loginWithApple(_ idToken: String, deviceId: String) async {
        do {
            let request = AppleLoginRequest(authorizationCode: idToken, deviceId: deviceId)
            let response: AppleLoginResponse = try await provider.async.request(.appleLogin(request: request))
            
            try KeychainManager.create(.accessToken, response.accessToken)
            try KeychainManager.create(.refreshToken, response.refreshToken)
            
            self.accessToken = response.accessToken
            self.refreshToken = response.refreshToken
            
            await MainActor.run {
                isNewUser = response.isNewUser
                authStatus = .loggedIn
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loginWithKakao(_ accessToken: String, deviceId: String) async throws {
        do {
            let request = KakaoLoginRequest(idToken: accessToken, deviceId: deviceId)
            let response: KakaoLoginResponse = try await provider.async.request(.kakaoLogin(request: request))
            
            try KeychainManager.create(.accessToken, response.accessToken)
            try KeychainManager.create(.refreshToken, response.refreshToken)
            
            self.accessToken = response.accessToken
            self.refreshToken = response.refreshToken
            
            await MainActor.run {
                isNewUser = response.isNewUser
                authStatus = .loggedIn
            }
        } catch {            
            print(error.localizedDescription)
            throw error
        }
    }
    
    /// 로그아웃 API
    func logout() async {
        do {
            let deviceId = DeviceIDManager.shared.getDeviceId()
            let request = LogoutRequest(deviceId: deviceId)
            
            try await provider.async.requestPlain(
                .logout(request: request)
            )
            
            logoutLocal()
        } catch {
            print("로그아웃 실패:", error.localizedDescription)
        }
    }
    
    func logoutLocal() {
        do {
            try KeychainManager.delete(.accessToken)
            try KeychainManager.delete(.refreshToken)
        } catch {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.authStatus = .loggedOut
        }
    }
    
    /// 탈퇴 API
    func withdraw() async {
        do {
            let request = WithdrawRequest(provider: "APPLE")
            try await provider.async.requestPlain(.withdraw(request: request))
            
            await MainActor.run {
                UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
                UserDefaults.standard.removeObject(forKey: "hasCompletedRegister")
                
                self.authStatus = .loggedOut
            }
            
            try KeychainManager.delete(.accessToken)
            try KeychainManager.delete(.refreshToken)
        } catch {
            print("회원탈퇴 실패:", error.localizedDescription)
        }
    }
}

extension AuthManager {
    /// 토큰 재발급 API
    func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken else {
            completion(false)
            return
        }
        
        let request = RefreshTokenRequest(
            refreshToken: refreshToken,
            deviceId: DeviceIDManager.shared.getDeviceId()
        )
        
        provider.request(.refreshToken(request: request)) { result in
            switch result {
            case .success(let response):
                guard (200..<300).contains(response.statusCode),
                      let decoded = try? JSONDecoder().decode(RefreshTokenResponse.self, from: response.data)
                else {
                    self.logoutLocal()
                    completion(false)
                    return
                }
                
                do {
                    try KeychainManager.create(.accessToken, decoded.accessToken)
                    try KeychainManager.create(.refreshToken, decoded.refreshToken)
                    
                    self.accessToken = decoded.accessToken
                    self.refreshToken = decoded.refreshToken
                    
                    completion(true)
                } catch {
                    self.logoutLocal()
                    completion(false)
                }
                
            case .failure:
                self.logoutLocal()
                completion(false)
            }
        }
    }
}
