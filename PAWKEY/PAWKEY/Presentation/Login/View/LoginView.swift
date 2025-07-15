//
//  LoginView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @EnvironmentObject var coordinator: Coordinator<OnboardingScene>
    
    @StateObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    Text("아이디")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $viewModel.idText, placeholder: "아이디")
                        .padding(.top, 10)
                }
                .padding(.top, 123)
                
                VStack(alignment: .leading) {
                    Text("비밀번호")
                        .font(.body_14_sb)
                    PawkeyTextField(text: $viewModel.passwordText, placeholder: "사용하실 비밀번호를 입력해주세요.", type: .password)
                        .padding(.top, 10)
                }
                .padding(.top, 37)
                .padding(.bottom, 154)
                
                CTAButton(title: "신규 계정으로 회원가입", buttonStyle: .borderless) {
                    coordinator.push(.profileSetUp)
                }
                CTAButton(title: "로그인", isDisabled: viewModel.isDisabled, buttonStyle: .filled) {
                    mainTabViewModel.isLogin = true
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
