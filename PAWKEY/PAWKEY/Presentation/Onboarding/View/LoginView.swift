//
//  LoginView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            Text("로그인 화면")
                .font(.largeTitle)
            
            Button("로그인 성공") {
                isLoggedIn = true
            }
        }
    }
}

struct RootView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            TabView()
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}
