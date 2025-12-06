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
                .font(isActive ? .subActive : .subDefault)
                .foregroundStyle(isActive ? .defaultPrimary : .defaultMiddle)
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(isActive ? .opacity5 : .defaultBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(isActive ? .defaultPrimary : .defaultMiddle, lineWidth: 1)
                )
        }
    }
}

#Preview {
    SelectButton(text: "차량 적음", isActive: true)
    SelectButton(text: "보도 차도 분리", isActive: false)
}
