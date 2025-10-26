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
                Text("로그인")
            case .loggedOut:
                Text("로그아웃")
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
