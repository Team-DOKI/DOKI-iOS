//
//  RootView.swift
//  DOKI
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var appDIContainer: AppDIContainer
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("hasCompletedRegister") var hasCompletedRegister: Bool = false
    @AppStorage("showDBTIStart") var showDBTIStart: Bool = false
    
    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            } else {
                switch authManager.authStatus {
                case .loading:
                    Text("스플래쉬")
                        .onAppear { authManager.checkLogin() }
                    
                case .loggedOut:
                    LoginCoordinatorView(viewModelFactory: appDIContainer.viewModelFactory)
                    
                case .loggedIn:
                    if !hasCompletedRegister {
                        RegisterView(
                            viewModel: appDIContainer.viewModelFactory.makeRegisterViewModel(),
                            hasCompletedRegister: $hasCompletedRegister,
                            showDBTIStart: $showDBTIStart
                        )
                    } else if showDBTIStart {
                        AfterRegisterDBTIFlow(
                            onFinish: {
                                showDBTIStart = false
                            }
                        )
                    } else {
                        MainTabView()
                            .environmentObject(TabBarState())
                    }
                }
            }
        }
    }
}
