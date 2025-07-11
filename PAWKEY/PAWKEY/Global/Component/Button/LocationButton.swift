//
//  LocationButton.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/9/25.
//

import SwiftUI

struct LocationButton: View {
    
    enum LocationButtonType {
        case medium
        case small
        
        var verticalPadding: CGFloat {
            switch self {
            case .medium:
                return 16
            case .small:
                return 10
            }
        }
    }
    
    let title: String
    let isSelected: Bool
    let buttonType: LocationButtonType
    
    var action: ((String) -> ())?
    
    private var font: Font {
        isSelected ? .body_14_sb : .body_14_r
    }

    private var foregroundColor: Color {
        isSelected ? .green500 : .gray200
    }

    private var borderColor: Color {
        isSelected ? .green500 : .gray50
    }

    private var lineWidth: CGFloat {
        isSelected ? 2 : 1
    }
    
    init(
        _ title: String,
        type: LocationButtonType = .medium,
        isSelected: Bool = false,
        action: ((String) -> ())? = nil
    ) {
        self.title = title
        self.buttonType = type
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button {
            action?(title)
        } label: {
            Text(title)
                .font(font)
                .foregroundColor(foregroundColor)
                .padding(.horizontal, 20)
                .padding(.vertical, buttonType.verticalPadding)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: lineWidth)
                )
                .cornerRadius(8)
        }
    }
}

#Preview {
    LocationButton("강남구", type: .small, isSelected: true)
}
