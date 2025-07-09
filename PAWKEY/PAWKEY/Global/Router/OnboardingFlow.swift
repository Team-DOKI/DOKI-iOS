//
//  OnboardingFlow.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct OnboardingFlow: View {
    @EnvironmentObject var router: TabRouter<OnboardingScreen>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            OnboardingView()
                .navigationDestination(for: OnboardingScreen.self) { screen in
                    build(screen: screen)
                }
        }
    }
    
    @ViewBuilder
    private func build(screen: OnboardingScreen) -> some View {
        switch screen {
        case .login:
            LoginView(isLoggedIn: .constant(false))
        case .profileSetUp:
            ProfileSetUpView()
        }
    }
}
