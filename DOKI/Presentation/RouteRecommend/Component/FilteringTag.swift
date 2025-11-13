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
        VStack {
            Text(text)
                .subDefault(color: isActive ? .defaultPrimary : .default)
                .padding(.vertical, 9)
                .padding(.horizontal, 10)
                .background(isActive ? .opacity5 : .defaultBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isActive ? .defaultPrimary : .defaultButton, lineWidth: 1)
                )
        }
        .padding(.vertical, 1)
    }
}
