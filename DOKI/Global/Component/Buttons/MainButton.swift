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
    case loading(base: MainButtonBase)
    case normal

    var backgroundColor: Color {
        switch self {
        case .active1:
            return .defaultPrimary
        case .active2:
            return .defaultBackground
        case .danger:
            return .clear
        case .disabled, .normal:
            return .defaultButton
        case .loading(let base):
            return base.backgroundColor
        }
    }

    var textColor: Color {
        switch self {
        case .active1:
            return .defaultBackground
        case .active2:
            return .defaultPrimary
        case .danger:
            return .defaultRed
        case .disabled:
            return .defaultMiddle
        case .normal:
            return .defaultDark
        case .loading(let base):
            return base.textColor
        }
    }

    var borderColor: Color {
        switch self {
        case .active2:
            return .defaultPrimary
        case .danger:
            return .defaultRed
        case .loading(let base):
            return base.borderColor
        default:
            return .clear
        }
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isDisabled: Bool {
        if case .disabled = self { return true }
        if case .loading = self { return true }
        return false
    }
}

enum MainButtonBase {
    case active1
    case active2
    case danger
    case normal

    var backgroundColor: Color {
        switch self {
        case .active1: return .defaultPrimary
        case .active2: return .defaultBackground
        case .danger: return .clear
        case .normal: return .defaultButton
        }
    }

    var textColor: Color {
        switch self {
        case .active1: return .defaultBackground
        case .active2: return .defaultPrimary
        case .danger: return .defaultRed
        case .normal: return .defaultDark
        }
    }

    var borderColor: Color {
        switch self {
        case .active2: return .defaultPrimary
        case .danger: return .defaultRed
        default: return .clear
        }
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
                Text(text)
                    .foregroundStyle(buttonState.isLoading ? Color.clear : buttonState.textColor)
                    .font(size.font)

                if buttonState.isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: buttonState.textColor)
                        )
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
        MainButton(text: "Loading", buttonState: .loading(base: .active1))
        
        Text("Medium")
            .frame(maxWidth: .infinity, alignment: .leading)
        
        MainButton(text: "Active1", buttonState: .active1, size: .medium)
        MainButton(text: "Active2", buttonState: .active2, size: .medium)
        MainButton(text: "Danger", buttonState: .danger, size: .medium)
        MainButton(text: "Disabled", buttonState: .disabled, size: .medium)
        MainButton(text: "Normal", buttonState: .normal, size: .medium)
        MainButton(text: "Loading", buttonState: .loading(base: .active1), size: .medium)
    }
    .padding()
}
