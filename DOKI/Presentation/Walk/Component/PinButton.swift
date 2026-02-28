//
//  PinButton.swift
//  DOKI
//
//  Created by 이세민 on 12/12/25.
//

import SwiftUI

struct PinButton: View {
    let icon: String
    let action: (() -> Void)
    
    @State private var isActive = false
    
    var body: some View {
        Button {
            isActive.toggle()
            action()
        } label: {
            Image(icon)
                .renderingMode(.template)
                .foregroundColor(isActive ? .defaultPrimary : .defaultDark)
                .padding(10)
                .background(.defaultBackground)
                .overlay(
                    Circle()
                        .inset(by: 0.5)
                        .stroke(isActive ? .defaultPrimary : Color.clear, lineWidth: 1)
                )
                .cornerRadius(50)
                .shadow(color: .contents.opacity(0.25), radius: 4, x: 0, y: 0)
        }
    }
}

#Preview {
    PinButton(icon: "ic_trash") { }
}
