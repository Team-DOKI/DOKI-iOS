//
//  MainButton.swift
//  PAWKEY
//
//  Created by 권석기 on 9/10/25.
//

import SwiftUI

enum MainButtonState {
    case active1
    case active2
    case disabled
    case loading
    
    var backgroundColor: Color {
        switch self {
        case .active1, .loading:
                .defaultPrimary
        case .active2:
                .defaultBackground
        case .disabled:
                .defaultButton
        }
    }
    
    var textColor: Color {
        switch self {
        case .active1, .loading:
                .defaultBackground
        case .active2:
                .defaultPrimary
        case .disabled:
                .defaultMiddle
        }
    }
    
    var isDisabled: Bool {
        self == .disabled || self == .loading
    }
}

struct MainButton: View {
    let text: String
    var buttonState: MainButtonState = .active1
    var font: Font = .mainActive
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                if buttonState == .loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(text)
                        .foregroundStyle(buttonState.textColor)
                        .font(font)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56)
        }
        .background(buttonState.backgroundColor)
        .overlay {
            if buttonState == .active2 {
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Color.defaultPrimary, lineWidth: 1)
            }
        }
        .disabled(buttonState.isDisabled)
        .cornerRadius(8)
    }
}

#Preview {
    MainButton(text: "TEXT", buttonState: .active1)
    MainButton(text: "TEXT", buttonState: .active2, font: .subtitle)
    MainButton(text: "TEXT", buttonState: .disabled)
}
