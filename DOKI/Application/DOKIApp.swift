//
//  DOKIApp.swift
//  DOKI
//
//  Created by 이세민 on 6/21/25.
//

import SwiftUI

@main
struct DOKIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appDIContainer = AppDIContainer()
    @StateObject var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
                .environmentObject(appDIContainer)
//                .onAppear {
//                    try? KeychainManager.delete(.accessToken)
//                    try? KeychainManager.delete(.refreshToken)
//                    try? KeychainManager.delete(.deviceId)
//                }
        }
    }
}
