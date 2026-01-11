//
//  AuthManager.swift
//  PAWKEY
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
    
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    
    private let provider = MoyaProvider<LoginAPI>(plugins: [NetworkLoggerPlugin()])
    
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
            let appleLoginReqDto = AppleLoginRequestDTO(authorizationCode: idToken, deviceId: deviceId)
            let response: BaseDTO<AppleLoginResponseDTO> = try await provider.async.request(.appleLogin(appleLoginReqDto: appleLoginReqDto))
            
            guard let data = response.data else { return }
            
            try KeychainManager.create(.accessToken, data.accessToken)
            try KeychainManager.create(.refreshToken, data.refreshToken)
            self.accessToken = data.accessToken
            self.refreshToken = data.refreshToken
            
            authStatus = .loggedIn
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logout() {
        do {
            try KeychainManager.delete(.accessToken)
            try KeychainManager.delete(.refreshToken)
            authStatus = .loggedOut
        } catch {
            print(error.localizedDescription)
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
}


