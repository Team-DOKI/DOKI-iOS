//
//  PAWKEYApp.swift
//  PAWKEY
//
//  Created by 이세민 on 6/21/25.
//

import SwiftUI

@main
struct PAWKEYApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AuthManager())
        }
    }
}
