//
//  FilteringTag.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

struct FilteringTag: View {
    let text: String
    let isActive: Bool
    var action: (()->())?
    
    var body: some View {
        Text(text)
            .font(isActive ? .subActive : .subDefault)
            .foregroundStyle(isActive ? .defaultPrimary : .defaultMiddle)
            .padding(.vertical, 9)
            .padding(.horizontal, 10)
            .background(isActive ? .opacity5 : .defaultBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(isActive ? .defaultPrimary : .defaultButton, lineWidth: 1)
            )
    }
}

#Preview {
    FilteringTag(text: "10분 이내", isActive: true)
}
