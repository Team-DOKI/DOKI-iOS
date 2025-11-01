//
//  LoginViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    private let loginCoordinator: Coordinator<LoginRoute>
    
    init(loginCoordinator: Coordinator<LoginRoute>) {
        self.loginCoordinator = loginCoordinator
    }
    
    func navigateToRegister() {        
        loginCoordinator.push(.register)
    }
}
