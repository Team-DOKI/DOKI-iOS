//
//  TextArea.swift
//  DOKI
//
//  Created by a on 1/11/26.
//

import SwiftUI

struct TextArea: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool    
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .bodyDefault(color: .defaultMiddle)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
            }
            
            TextEditor(text: $text)
                .focused($isFocused)
                .font(.bodyDefault)
                .scrollContentBackground(.hidden)
                .padding(16)
                .frame(height: 214)
        }
        .background(.defaultBright)
        .cornerRadius(8)
    }
}
