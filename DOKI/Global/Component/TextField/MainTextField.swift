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
    
    var isError: Bool? = nil
    
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.leading, 16)
            .font(.bodyActive)
            .focused($fieldIsFocused)
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(.defaultBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.defaultMiddle, lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isError == true ? Color.defaultRed : (fieldIsFocused ? Color.defaultPrimary : .clear), lineWidth: 1)
            )
    }
}

#Preview {
    MainTextField(placeholder: "text", text: .constant(""))
}
