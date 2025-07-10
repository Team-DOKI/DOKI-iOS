//
//  PKTextField.swift
//  PAWKEY
//
//  Created by 권석기 on 7/7/25.
//

import SwiftUI

struct PKTextField: View {
    
    enum TextFieldType {
        case normal
        case password
        case number
    }
    
    @State var isShowPassword = false
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var placeholder: String?
    var type: TextFieldType = .normal
    
    var body: some View {
        ZStack {
            VStack {
                switch type {
                case .normal:
                    TextField(text: $text) {
                        Text(placeholder ?? "입력해주세요")
                            .font(.body_14_r)
                            .foregroundStyle(.gray200)
                    }
                    .focused($isFocused)
                case .password:
                    HStack {
                        ZStack {
                            SecureField("", text: $text)
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
                    TextField(text: $text) {
                        Text(placeholder ?? "입력해주세요")
                            .font(.body_14_r)
                            .foregroundStyle(.gray200)
                    }
                    .focused($isFocused)
                    .keyboardType(.numberPad)
                }
            }
            .padding(.leading, 16)
        }
        .frame(height: 52.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(lineWidth: 1)
                .foregroundStyle(isFocused ? .black : .gray200)
        )
    }
}

#Preview {
    PKTextField(text: .constant(""), placeholder: "비번입력", type: .password)
        .padding(.horizontal, 20)
}
