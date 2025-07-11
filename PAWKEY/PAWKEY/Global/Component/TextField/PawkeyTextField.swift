//
//  PawkeyTextField.swift
//  PAWKEY
//
//  Created by 권석기 on 7/7/25.
//

import SwiftUI

struct PawkeyTextField: View {
    
    enum TextFieldType {
        case normal
        case password
        case number
    }
    
    @State private var isShowPassword = false
    
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var placeholder: String?
    var type: TextFieldType = .normal
    
    private var placeholderText: String {
        placeholder ?? "입력해주세요"
    }
    
    private var normalTextField: some View {
        TextField(placeholderText, text: $text)
            .font(.body_14_r)
            .focused($isFocused)
    }
    
    private var passwordTextField: some View {
        HStack {
            ZStack {
                SecureField(placeholderText, text: $text)
                    .font(.body_14_r)
                    .opacity(isShowPassword ? 0 : 1)
                    .focused($isFocused)
                
                TextField(placeholderText, text: $text)
                    .font(.body_14_r)
                    .opacity(isShowPassword ? 1 : 0)
                    .focused($isFocused)
            }
            Button {
                isShowPassword.toggle()
            } label: {
                Image(isShowPassword ? .eyeGray : .eyeSlashGray)
                    .padding(.trailing, 16)
            }
        }
    }
    
    private var numberTextField: some View {
        TextField(placeholderText, text: $text)
            .keyboardType(.numberPad)
            .focused($isFocused)
            .font(.body_14_r)
    }
    
    var body: some View {
        Group {
            switch type {
            case .normal:
                normalTextField
            case .password:
                passwordTextField
            case .number:
                numberTextField
            }
        }
        .padding(.leading, 16)
        .frame(height: 52)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundStyle(isFocused ? .black : .gray200)
        )
    }
}

#Preview {
    PawkeyTextField(text: .constant(""), placeholder: "비밀번호 입력", type: .password)
        .padding(.horizontal, 20)
}
