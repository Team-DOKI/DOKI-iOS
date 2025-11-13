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
    
    var action: (()->())?
    
    var body: some View {
            Button {
                action?()
            } label: {
                Text(text)
                    .subDefault(color: isActive ? .defaultPrimary : .default)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(isActive ? .opacity5 : .defaultBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isActive ? .defaultPrimary : .defaultButton, lineWidth: 1)
                    )
            }
            .padding(1)
    }
}
