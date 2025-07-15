//
//  PAWKEYApp.swift
//  PAWKEY
//
//  Created by 이세민 on 6/21/25.
//

import SwiftUI

@main
struct PAWKEYApp: App {
    @StateObject private var onboardingCoordinator = Coordinator<OnboardingScene>()
    @StateObject private var homeCoordinator = Coordinator<HomeScene>()
    @StateObject private var walkCoordinator = Coordinator<WalkScene>()
    @StateObject private var myPageCoordinator = Coordinator<MyPageScene>()
    @StateObject private var mainTabViewModel = MainTabViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(homeCoordinator)
                .environmentObject(walkCoordinator)
                .environmentObject(onboardingCoordinator)
                .environmentObject(myPageCoordinator)
                .environmentObject(mainTabViewModel)
        }
    }
}
