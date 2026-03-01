//
//  LoginCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum LoginRoute: Route {
    case register
}

struct LoginCoordinatorView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var loginViewModel: LoginViewModel
    
    let viewModelFactory: AppDIContainer.ViewModelFactory
    
    init(viewModelFactory: AppDIContainer.ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self._loginViewModel = StateObject(
            wrappedValue: viewModelFactory.makeLoginViewModel()
        )
    }
    
    var body: some View {
        NavigationStack {
            LoginView(viewModel: loginViewModel)
        }
    }
}
