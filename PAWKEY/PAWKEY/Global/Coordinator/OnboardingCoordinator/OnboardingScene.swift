//
//  OnboardingScene.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

enum OnboardingScene: AppScene {
    case login
    case profileSetUp
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .login:
            LoginView(isLoggedIn: .constant(false))
        case .profileSetUp:
            ProfileSetUpView()
        }
    }
}
