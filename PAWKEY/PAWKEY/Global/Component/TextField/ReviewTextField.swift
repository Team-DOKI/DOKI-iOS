//
//  ReviewTextField.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/9/25.
//

import SwiftUI

enum TextFieldType { // TODO: 기능 분리
    case title
    case body
    
    var placeholder: String {
        switch self {
        case .title:
            return "후기 제목을 입력해 주세요."
        case .body:
            return "산책 후기를 간단하게 적어주세요!"
        }
    }
    
    var font: Font {
        switch self {
        case .title:
            return .body_14_r
        case .body:
            return .body_14_r
        }
    }
    
    var height: CGFloat {
        switch self {
        case .title:
            return 54
        case .body:
            return 214
        }
    }
    
}


struct ReviewTextField: View {
    let type: TextFieldType
    @Binding var text: String
    
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if type == .title {
            TextField(type.placeholder, text: $text)
                .font(type.font)
                .padding(20)
                .frame(width: 343, height: type.height)
                .focused($isFocused)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color.pawkeyBlack : Color.gray50.opacity(0.5), lineWidth: 1)
                )
                .background(Color.pawkeyWhite2)
        } else {
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .font(type.font)
                .padding(.leading, 16)
                .padding(.top, 12)
                .frame(width: 343, height: type.height)
                .background(Color.clear)
                .focused($isFocused)
                .overlay(alignment: .topLeading) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Color.pawkeyBlack : Color.gray50.opacity(0.5), lineWidth: 1)
                        Text(type.placeholder)
                            .foregroundStyle(text.isEmpty ? .gray200 : .clear)
                            .font(type.font)
                            .padding(.leading, 20)
                            .padding(.top, 12)
                    }
                }
                
                .background(Color.pawkeyWhite2)
        }
    }
}

#Preview {
    ReviewTextField(type: .body, text: .constant(""))
}
