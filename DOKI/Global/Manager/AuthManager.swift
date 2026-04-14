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
    private(set) var petId: Int = 0
    private(set) var userId: Int = 0
    private(set) var provider: String = ""
    
    private let authProvider = MoyaProvider<AuthAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    private init() {}
    
    func checkLogin() {
        do {
            self.accessToken = try KeychainManager.read(.accessToken)
            self.refreshToken = try KeychainManager.read(.refreshToken)

            if let petIdString = try? KeychainManager.read(.petId), let id = Int(petIdString ?? "") {
                self.petId = id
            }
            if let userIdString = try? KeychainManager.read(.userId), let id = Int(userIdString ?? "") {
                self.userId = id
            }
            if let savedProvider = try? KeychainManager.read(.provider) {
                self.provider = savedProvider ?? ""
            }

            authStatus = .loggedIn
        } catch {
            authStatus = .loggedOut
            print(error.localizedDescription)
        }
    }

    func saveUserSession(userId: Int, petId: Int) {
        do {
            try KeychainManager.create(.userId, String(userId))
            try KeychainManager.create(.petId, String(petId))
            self.userId = userId
            self.petId = petId
        } catch {
            print("유저 세션 저장 실패:", error.localizedDescription)
        }
    }
    
    /// 애플 로그인 API
    func loginWithApple(_ idToken: String, deviceId: String) async {
        do {
            let request = AppleLoginRequest(authorizationCode: idToken, deviceId: deviceId)
            let response: AppleLoginResponse = try await authProvider.async.request(.appleLogin(request: request))

            try KeychainManager.create(.accessToken, response.accessToken)
            try KeychainManager.create(.refreshToken, response.refreshToken)
            try KeychainManager.create(.provider, "APPLE")

            self.accessToken = response.accessToken
            self.refreshToken = response.refreshToken
            self.provider = "APPLE"

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
            let response: KakaoLoginResponse = try await authProvider.async.request(.kakaoLogin(request: request))

            try KeychainManager.create(.accessToken, response.accessToken)
            try KeychainManager.create(.refreshToken, response.refreshToken)
            try KeychainManager.create(.provider, "KAKAO")

            self.accessToken = response.accessToken
            self.refreshToken = response.refreshToken
            self.provider = "KAKAO"

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
            
            try await authProvider.async.requestPlain(
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
            try? KeychainManager.delete(.petId)
            try? KeychainManager.delete(.userId)
            try? KeychainManager.delete(.provider)
        } catch {
            print(error.localizedDescription)
        }

        self.petId = 0
        self.userId = 0
        self.provider = ""

        DispatchQueue.main.async {
            self.authStatus = .loggedOut
        }
    }
    
    /// 탈퇴 API
    func withdraw() async {
        do {
            let request = WithdrawRequest(provider: provider)
            try await authProvider.async.requestPlain(.withdraw(request: request))
            
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
        
        authProvider.request(.refreshToken(request: request)) { result in
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
