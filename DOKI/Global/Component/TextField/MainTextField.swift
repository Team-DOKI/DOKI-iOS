//
//  MainTextField.swift
//  PAWKEY
//
//  Created by 권석기 on 9/12/25.
//

import SwiftUI

struct MainTextField: View {
    let placeholder: String    
    @Binding var text: String
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                .padding(.leading, 16)
                .font(.pretendard(size: 14, weight: .medium))
                .focused($fieldIsFocused)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(fieldIsFocused ? .defaultPrimary : .defaultMiddle, lineWidth: 1)
        )
    }
}

#Preview {
    MainTextField(placeholder: "text", text: .constant(""))
}
