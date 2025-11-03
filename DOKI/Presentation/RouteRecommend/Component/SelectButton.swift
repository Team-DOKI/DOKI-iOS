//
//  SelectButton.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

struct SelectButton: View {
    let text: String
    let isActive: Bool
    
    var activeColor: Color {
        isActive ? .defaultPrimary : .defaultButton
    }
    var action: (()->())?
    
    var body: some View {
        VStack {
            Text(text)
                .subDefault(color: isActive ? .defaultPrimary : .default)
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(isActive ? .opacity5 : .defaultBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1.0)
                        .foregroundStyle(activeColor)
                )
        }
        .padding(.vertical, 1)
    }
}
