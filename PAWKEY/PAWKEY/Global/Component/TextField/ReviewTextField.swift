//
//  ReviewTextField.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/9/25.
//

import SwiftUI

struct ReviewTextField: View {
    
    enum TextFieldType {
        case normal
        
        var placeholder: String {
            switch self {
            case .normal:
                return "후기 제목을 입력해 주세요."
            }
        }
        
        var height: CGFloat {
            switch self {
            case .normal:
                return 54
            }
        }
        
        var font: Font {
            switch self {
            case .normal:
                return .body_14_r
            }
        }
    }
    
    let type: TextFieldType
    
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Group {
            switch type {
            case .normal:
                TextField(type.placeholder, text: $text)
                    .font(type.self.font)
                    .frame(width: 343, height: type.height)
                    .frame(maxWidth: .infinity, maxHeight: type.height)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Color.pawkeyBlack : Color.gray50.opacity(0.5), lineWidth: 1)
                    )
                    .background(Color.pawkeyWhite2)
            }
        }
    }
}

#Preview {
    ReviewTextField(type: .normal, text: .constant(""))
}
