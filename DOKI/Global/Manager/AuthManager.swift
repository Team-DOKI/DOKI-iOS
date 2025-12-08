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
    
    private let provider = MoyaProvider<LoginAPI>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func checkLogin() {
        do {
            try KeychainManager.read(.refreshToken)
            try KeychainManager.read(.accessToken)
            authStatus = .loggedIn
        } catch {
            authStatus = .loggedOut
            print(error.localizedDescription)
        }
    }
    
    /// AppleLogin API
    func loginWithApple(_ idToken: String, deviceId: String) async {
        do {
            let appleLoginReqDto = AppleLoginRequestDTO(idToken: idToken, deviceId: deviceId)
            let response: AppleLoginResponseDTO = try await provider.async.request(.appleLogin(appleLoginReqDto: appleLoginReqDto))
            try KeychainManager.create(.accessToken, response.accessToken)
            try KeychainManager.create(.refreshToken, response.refreshToken)
            authStatus = .loggedIn
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logout() {
        do {
            try KeychainManager.delete(.accessToken)
            try KeychainManager.delete(.refreshToken)
        } catch {
            print(error.localizedDescription)
        }
    }
}


