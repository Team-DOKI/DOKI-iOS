//
//  MainTextField.swift
//  DOKI
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
                .font(.bodyActive)
                .focused($fieldIsFocused)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .background(.defaultBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(fieldIsFocused ? .defaultPrimary : .defaultMiddle, lineWidth: 1)
        )
    }
}

#Preview {
    MainTextField(placeholder: "text", text: .constant(""))
}
