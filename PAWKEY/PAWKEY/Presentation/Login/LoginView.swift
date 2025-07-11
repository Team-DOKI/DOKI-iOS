//
//  LoginView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    
    @State private var idText = ""
    @State private var passwordText = ""
    
    @EnvironmentObject var tabBarState: TabBarState
    @EnvironmentObject var router: Coordinator<OnboardingScreen>
    
    var isDisabled: Bool {
        idText.isEmpty || passwordText.isEmpty
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    Text("아이디")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $idText, placeholder: "아이디")
                        .padding(.top, 10)
                }
                .padding(.top, 123)
                
                VStack(alignment: .leading) {
                    Text("비밀번호")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $passwordText, placeholder: "사용하실 비밀번호를 입력해주세요.", type: .password)
                        .padding(.top, 10)
                }
                .padding(.top, 37)
                .padding(.bottom, 154)
                
                CTAButton(title: "신규 계정으로 회원가입", buttonStyle: .borderless) {
                    router.push(.profileSetUp)
                }
                CTAButton(title: "로그인", isDisabled: isDisabled, buttonStyle: .filled) {
                    tabBarState.isLogin = true
                }
                .padding(.top, 12)
                .padding(.bottom, 60)
            }
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .topNavigationView(center: {
            Text("기존 계정으로 로그인")
                .font(.body_16_sb)
        })
    }
}

struct RootView: View {
    @State private var isLoggedIn = false
    @EnvironmentObject var tabBarState: TabBarState
    var body: some View {
        if tabBarState.isLogin {
            MainTabView()
        } else {
            OnboardingCoordinator()
        }
    }
}
