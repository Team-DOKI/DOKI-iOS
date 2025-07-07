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
        case outlined
        
        // TODO: 디자인시스템 정해지면 색상 바꾸기
        func backgroundColor(isDisabled: Bool) -> Color {
            switch self {
            case .filled:
                return isDisabled ? .gray200 : .beige500
            case .outlined:
                return .clear
            }
        }
        
        func textColor(isDisabled: Bool) -> Color {
            switch self {
            case .filled:
                return  isDisabled ? .gray50 : .white
            case .outlined:
                return isDisabled ? .gray200 : .beige500
            }
        }
        
        func borderColor(isDisabled: Bool) -> Color {
            switch self {
            case .filled:
                return .clear
            case .outlined:
                return .clear
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
                .foregroundStyle(buttonStyle.textColor(isDisabled: isDisabled))
                .font(.body_16_sb)
                .frame(maxWidth: .infinity, maxHeight: 52.0)
        }
        .background(buttonStyle.backgroundColor(isDisabled: isDisabled))
        .cornerRadius(8.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0).stroke(lineWidth: 2).foregroundStyle(buttonStyle.borderColor(isDisabled: isDisabled))
        )
        .disabled(isDisabled)
    }
}

#Preview {
    SubmitButton(title: "버튼", isDisabled: false, buttonStyle: .filled)
        .padding(.horizontal, 20)
}
