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
        VStack {
            Text("로그인 뷰")
            Button {
                viewModel.navigateToRegister()
            } label: {
                Text("회원가입")
            }
        }
    }
}
