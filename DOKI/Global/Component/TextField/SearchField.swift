//
//  SearchField.swift
//  PAWKEY
//
//  Created by 권석기 on 9/12/25.
//

import SwiftUI

struct SearchField: View {
    let placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(.leading, 16)
                .font(.bodyActive)
            
            Image(.icSearch)
                .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.defaultMiddle, lineWidth: 1)
        )
    }
}

#Preview {
    SearchField(placeholder: "text", text: .constant(""))
}
