//
//  RootView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appDIContainer: AppDIContainer
    
    var body: some View {
        Group {
            switch authManager.authStatus {
            case .loggedIn:
                MainTabView()
            case .loggedOut:
                LoginCoordinatorView(viewModelFactory: appDIContainer.viewModelFactory)
            case .loading:
                Text("스플래쉬")
                    .onAppear {
                        authManager.checkLogin()
                    }
            }
        }
        .overlay {
            OnboardingView()
        }
    }
}

struct Breed: Hashable {
    let name: String
    var isChecked: Bool = false
}
