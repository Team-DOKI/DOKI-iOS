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
        authStatus = .loggedOut
    }
    
    /// AppleLogin API
    func requestAppleLogin(_ idToken: String, deviceId: String) async {
        do {
            let appleLoginReqDto = AppleLoginRequestDTO(idToken: idToken, deviceId: deviceId)
            let response: BaseDTO<String> = try await provider.async.request(.appleLogin(appleLoginReqDto: appleLoginReqDto))
        } catch {
            print(error.localizedDescription)
        }
    }
}


