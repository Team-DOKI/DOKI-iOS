//
//  RootView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            switch authManager.authStatus {
            case .loggedIn:
                LoginView()
            case .loggedOut:
                LoginView()
            case .loading:
                Text("스플래쉬")
                    .onAppear {
                        authManager.checkLogin()
                    }
            }
        }
        .padding()
    }
}

struct Breed: Hashable {
    let name: String
    var isChecked: Bool = false
}
