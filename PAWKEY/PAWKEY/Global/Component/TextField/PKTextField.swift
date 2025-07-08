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
    }
    
    @State var isShowPassword = false
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var placeholder: String?
    var type: TextFieldType = .normal
    
    var body: some View {
        ZStack {
            Group {
                if type == .password {
                    HStack {
                        ZStack {
                            SecureField("", text: $text)
                                .opacity(isShowPassword ? 0 : 1)
                                .focused($isFocused)
                                .font(.pretendard(size: 14, weight: .regular))
                            
                            
                            TextField(placeholder ?? "입력해주세요", text: $text)
                                .opacity(isShowPassword ? 1 : 0)
                                .focused($isFocused)
                                .font(.pretendard(size: 14, weight: .regular))
                        }
                        
                        Button {
                            isShowPassword.toggle()
                        } label: {
                            Text(isShowPassword ? "hide" : "show")
                        }
                    }
                } else {
                    TextField(text: $text) {
                        Text(placeholder ?? "입력해주세요")
                            .font(.pretendard(size: 14, weight: .regular))
                            .foregroundStyle(.gray200)
                    }
                    .focused($isFocused)
                }
            }
            .padding(.leading, 20)
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
