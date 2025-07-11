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
    
    var body: some View {
        Group {
            switch type {
            case .normal:
                TextField(placeholder ?? "입력해주세요", text: $text)
                    .focused($isFocused)
                    .font(.body_14_r)
                
            case .password:
                HStack {
                    ZStack {
                        SecureField(placeholder ?? "입력해주세요", text: $text)
                            .opacity(isShowPassword ? 0 : 1)
                            .focused($isFocused)
                            .font(.body_14_r)
                        
                        TextField(placeholder ?? "입력해주세요", text: $text)
                            .opacity(isShowPassword ? 1 : 0)
                            .focused($isFocused)
                            .font(.body_14_r)
                    }
                    
                    Button {
                        isShowPassword.toggle()
                    } label: {
                        Image(isShowPassword ? .eyeGray : .eyeSlashGray)
                            .padding(.trailing, 16)
                    }
                }
                
            case .number:
                TextField(placeholder ?? "입력해주세요", text: $text)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .font(.body_14_r)
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
