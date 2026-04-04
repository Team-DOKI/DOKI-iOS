//
//  MainButton.swift
//  DOKI
//
//  Created by 권석기 on 9/10/25.
//

import SwiftUI

enum MainButtonState {
    case active1
    case active2
    case danger
    case disabled
    case loading
    case normal
    
    var backgroundColor: Color {
        switch self {
        case .active1, .loading:
            return .defaultPrimary
        case .active2:
            return .defaultBackground
        case .danger:
            return .clear
        case .disabled, .normal:
            return .defaultButton
        }
    }
    
    var textColor: Color {
        switch self {
        case .active1, .loading:
            return .defaultBackground
        case .active2:
            return .defaultPrimary
        case .danger:
            return .defaultRed
        case .disabled:
            return .defaultMiddle
        case .normal:
            return .defaultDark
        }
    }
    
    var borderColor: Color {
        switch self {
        case .active2:
            return .defaultPrimary
        case .danger:
            return .defaultRed
        default:
            return .clear
        }
    }
    
    var isDisabled: Bool {
        self == .disabled || self == .loading
    }
}

enum MainButtonSize {
    case large
    case medium
    
    var font: Font {
        switch self {
        case .large:
            return .mainActive
        case .medium:
            return .subtitle
        }
    }
}

struct MainButton: View {
    let text: String
    var buttonState: MainButtonState = .active1
    var size: MainButtonSize = .large
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                if buttonState == .loading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: buttonState.textColor)
                        )
                } else {
                    Text(text)
                        .foregroundStyle(buttonState.textColor)
                        .font(size.font)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(buttonState.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .strokeBorder(
                    buttonState.borderColor,
                    lineWidth: 1
                )
        )
        .disabled(buttonState.isDisabled)
    }
}

#Preview {
    VStack(spacing: 12) {
        Text("Large")
            .frame(maxWidth: .infinity, alignment: .leading)
        
        MainButton(text: "Active1", buttonState: .active1)
        MainButton(text: "Active2", buttonState: .active2)
        MainButton(text: "Danger", buttonState: .danger)
        MainButton(text: "Disabled", buttonState: .disabled)
        MainButton(text: "Normal", buttonState: .normal)
        MainButton(text: "Loading", buttonState: .loading)
        
        Text("Medium")
            .frame(maxWidth: .infinity, alignment: .leading)
        
        MainButton(text: "Active1", buttonState: .active1, size: .medium)
        MainButton(text: "Active2", buttonState: .active2, size: .medium)
        MainButton(text: "Danger", buttonState: .danger, size: .medium)
        MainButton(text: "Disabled", buttonState: .disabled, size: .medium)
        MainButton(text: "Normal", buttonState: .normal, size: .medium)
        MainButton(text: "Loading", buttonState: .loading, size: .medium)
    }
    .padding()
}
