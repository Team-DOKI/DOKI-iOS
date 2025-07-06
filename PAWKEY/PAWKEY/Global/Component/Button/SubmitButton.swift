//
//  SubmitButton.swift
//  PAWKEY
//
//  Created by 권석기 on 7/6/25.
//

import SwiftUI

struct SubmitButton: View {
    
    enum SubmitButtonStyle {
        case filled
        case filledInactive
        case outlined
        case outlinedInactive
        
        var backgroundColor: Color {
            switch self {
            case .filled:
                return .green
            case .filledInactive:
                return .white
            case .outlined:
                return .clear
            case .outlinedInactive:
                return .clear
            }
        }
        
        var buttonTextColor: Color {
            switch self {
            case .filled:
                return .white
            case .filledInactive:
                return .gray
            case .outlined:
                return .green
            case .outlinedInactive:
                return .gray
            }
        }
    }
    
    let title: String
    
    var isDisabled: Bool = false
    var buttonStyle: SubmitButtonStyle = .filled
    var action: (()->())?
    
    var body: some View {
        Button {
            action?()
        } label: {
            Text(title)
                .foregroundStyle(buttonStyle.buttonTextColor)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: 52.0)
        }
        .background(buttonStyle.backgroundColor)
        .cornerRadius(8.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0).stroke(lineWidth: 2).foregroundStyle(buttonStyle.buttonTextColor)
        )
    }
}

#Preview {
    SubmitButton(title: "버튼", buttonStyle: .filled)
        .padding(.horizontal, 20)
}
