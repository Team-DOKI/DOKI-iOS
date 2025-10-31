//
//  LoginView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.logo)
                .padding(.top, 128)
            Text("도키와 도키도키한 \n산책을 시작해요!")
                .font(.pretendard(size: 20, weight: .bold))
                .foregroundStyle(.contents)
                .padding(.top, 21)
            Spacer()
            KakaoLoginButton {
                viewModel.navigateToRegister()
            }
            AppleLoginButton {
                
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 16)
        .overlay(alignment: .trailing) {
            Image(.loginDog)
        }
    }
}
