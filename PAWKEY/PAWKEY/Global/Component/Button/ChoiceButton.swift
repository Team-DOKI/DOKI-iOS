//
//  ChoiceButton.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/9/25.
//

import SwiftUI

struct ChoiceButton: View {
    
    enum ChoiceButtonType {
        case medium
        case small
        
        var edgeInsets: EdgeInsets {
            switch self {
            case .medium:
                return .init(top: 15, leading: 70, bottom: 15, trailing: 70)
            case .small:
                return .init(top: 10, leading: 20, bottom: 10, trailing: 20)
            }
        }
    }
    
    let title: String
    var type: ChoiceButtonType = .medium
    @State private var isSelected = false

    init(_ title: String, type: ChoiceButtonType = .medium) {
        self.title = title
        self.type = type
    }

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text(title)
                .font(isSelected ? .body_14_sb : .body_14_r)
                .foregroundColor(isSelected ? .green500 : .gray200)
                .padding(.horizontal, 20)
                .padding(.vertical, type.edgeInsets.top)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.green500 : Color.gray50, lineWidth: isSelected ? 2 : 1)
                )
                .cornerRadius(8)
        }
    }
}
