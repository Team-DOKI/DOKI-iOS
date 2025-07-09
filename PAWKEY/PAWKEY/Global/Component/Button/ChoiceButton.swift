//
//  ChoiceButton.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/9/25.
//

import SwiftUI

struct ChoiceButton: View {
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
                .foregroundColor(isSelected ? .green500 : .gray200)
                .padding(.vertical, 15)
                .padding(.horizontal, 70)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.green500 : Color.gray50, lineWidth: isSelected ? 2 : 1)
                )
                .cornerRadius(8)
        }
    }
}
