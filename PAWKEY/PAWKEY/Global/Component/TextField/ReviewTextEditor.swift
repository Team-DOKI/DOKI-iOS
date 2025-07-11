//
//  ReviewTextEditor.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import SwiftUI

struct ReviewTextEditor: View {
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var placeholder: String {
        return "산책 후기를 간단하게 적어주세요!"
    }
    
    var borderColor: Color {
        text.isEmpty ? .gray200 : .clear
    }
    
    var body: some View {
        TextEditor(text: $text)
            .scrollContentBackground(.hidden)
            .font(.body_14_r)
            .padding(.leading, 16)
            .padding(.top, 12)
            .frame(maxWidth: .infinity, minHeight: 214)
            .background(Color.clear)
            .focused($isFocused)
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color.pawkeyBlack : Color.gray50.opacity(0.5), lineWidth: 1)
                    Text(placeholder)
                        .foregroundStyle(borderColor)
                        .font(.body_14_r)
                        .padding(.leading, 20)
                        .padding(.top, 20)
                }
            }
            .background(Color.pawkeyWhite2)
    }
}

#Preview {
    ReviewTextEditor(text: .constant(""))
}
