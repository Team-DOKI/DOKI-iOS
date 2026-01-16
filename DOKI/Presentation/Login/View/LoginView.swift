//
//  LoginView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.imgLogo)
                .padding(.top, 127)
                .padding(.leading, 35)
            
            Text("도키와 도키도키한 \n산책을 시작해요!")
                .font(.header3)
                .foregroundStyle(.contents)
                .padding(.top, 21)
                .padding(.leading, 35)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 0) {
                Image(.imgSignmessage)
                    .padding(.bottom, 10)
                
                KakaoLoginButton {
                    viewModel.navigateToRegister()
                }
                .padding(.horizontal, 16)
                
                AppleLoginButton {}
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .overlay(
                    SignInWithAppleButton(
                        onRequest: viewModel.requestAppleLogin(_:),
                        onCompletion: viewModel.onCompleteAppleLogin(_:)
                    )
                    .frame(height: 50)
                    .blendMode(.destinationOver)
                )
            }
        }
        .overlay(alignment: .trailing) {
            Image(.imgLogindog)
        }
    }
}
