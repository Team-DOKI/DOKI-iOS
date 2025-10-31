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
    
    @AppStorage("isOnboarding") var isOnboardingCompleted: Bool = UserDefaults.standard.bool(forKey: "isOnboarding")

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
            if !isOnboardingCompleted {
                OnboardingView(isOnboarding: $isOnboardingCompleted)
            }
        }
    }
}

