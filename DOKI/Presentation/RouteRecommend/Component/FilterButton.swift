//
//  FilterButton.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

struct FilterButton: View {
    let isActive: Bool
    
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Image(.filterIcon)
                .renderingMode(.template)
                .foregroundStyle(isActive ? .defaultPrimary : .defaultMiddle)
        }
        .padding(6)
        .background(isActive ? .opacity5 : .defaultBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isActive ? .defaultPrimary : .defaultButton, lineWidth: 1)
        )
    }
}

#Preview {
    FilterButton(isActive: true)
}
