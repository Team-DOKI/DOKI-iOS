//
//  FilterButton.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

struct FilterButton: View {
    let isActive: Bool
    
    var activeColor: Color {
        isActive ? .defaultPrimary : .defaultButton
    }
    var action: (()->())?
    
    var body: some View {
        Button {
            action?()
        } label: {
            Image(.filterIcon)
                .renderingMode(.template)
                .foregroundStyle(activeColor)
        }
        .padding(5.74)
        .background(isActive ? .opacity5 : .defaultButton)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1.0)
                .foregroundStyle(activeColor)
        )
    }
}

#Preview {
    FilterButton(isActive: true)
}
