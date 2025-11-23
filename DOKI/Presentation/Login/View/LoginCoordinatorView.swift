//
//  LoginCoordinatorView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum LoginRoute: Route {
    case register
}

struct LoginCoordinatorView: View {
    @StateObject var loginCoordinator: Coordinator<LoginRoute>
    @StateObject var loginViewModel: LoginViewModel
    
    let viewModelFactory: AppDIContainer.ViewModelFactory
    
    init(loginCoordinator: Coordinator<LoginRoute> = Coordinator<LoginRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self._loginCoordinator = StateObject(wrappedValue: loginCoordinator)
        self._loginViewModel = StateObject(wrappedValue: viewModelFactory.makeLoginViewModel(loginCoordinator))
    }
    
    var body: some View {
        NavigationStack(path: $loginCoordinator.path) {
            LoginView(viewModel: loginViewModel)
                .navigationDestination(for: LoginRoute.self) { destination in
                    switch destination {
                    case .register:
                        let viewModel = viewModelFactory.makeRegisterViewModel()
                        RegisterView(viewModel: viewModel)
                    }
                }
        }
    }
}
