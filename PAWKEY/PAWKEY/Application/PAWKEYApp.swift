//
//  PAWKEYApp.swift
//  PAWKEY
//
//  Created by 이세민 on 6/21/25.
//

import SwiftUI

@main
struct PAWKEYApp: App {
    @StateObject private var onboardingFlow = Coordinator<OnboardingScreen>()
    @StateObject private var tabBarState = TabBarState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(onboardingFlow)
                .environmentObject(tabBarState)
        }
    }
}
