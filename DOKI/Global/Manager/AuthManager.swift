//
//  AuthManager.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum AuthState: String, CaseIterable {
    case loggedIn
    case loggedOut
    case loading
}

class AuthManager: ObservableObject {
    @Published var authStatus: AuthState = .loading
    
    func checkLogin() {
        authStatus = .loggedIn
    }
    
    func login() {
        authStatus = .loggedIn
    }
}
