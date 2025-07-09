//
//  ReviewOptionButton.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/9/25.
//

import SwiftUI

struct ReviewOptionButton: View {
    let title: String
    @State private var isSelected = false

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text(title)
                .font(isSelected ? .body_14_sb : .body_14_r)
                .foregroundColor(isSelected ? .green500 : .gray400)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.green500 : Color.gray50, lineWidth: isSelected ? 2 : 1)
                )
                .cornerRadius(8)
        }
    }
}

