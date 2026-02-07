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
    
    /// AppleLogin API
    func loginWithApple(_ idToken: String, deviceId: String) async {
        do {
            let request = AppleLoginRequestDTO(authorizationCode: idToken, deviceId: deviceId)
            let response: AppleLoginResponseDTO = try await provider.async.request(.appleLogin(request: request))
            
            try KeychainManager.create(.accessToken, response.accessToken)
            try KeychainManager.create(.refreshToken, response.refreshToken)
            
            self.accessToken = response.accessToken
            self.refreshToken = response.refreshToken
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.isNewUser = response.isNewUser
                self.authStatus = .loggedIn
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Logout API
    func logout() async {
        do {
            let deviceId = DeviceIDManager.shared.getDeviceId()
            let request = LogoutRequestDTO(deviceId: deviceId)
            
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
    
    func reissueToken(accessToken: String, refreshToken: String) {
        do {
            try KeychainManager.create(.accessToken, accessToken)
            try KeychainManager.create(.refreshToken, refreshToken)
            self.accessToken = accessToken
            self.refreshToken = refreshToken
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// withdraw API
    func withdraw() async {
        do {
            let request = WithdrawRequestDTO(provider: "APPLE")
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
