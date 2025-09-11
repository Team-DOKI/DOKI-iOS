//
//  MainButton.swift
//  PAWKEY
//
//  Created by 권석기 on 9/10/25.
//

import SwiftUI

struct MainButton: View {
    enum MainButtonState {
        case `default`
        case disabled
        case loading
        
        var backgroundColor: Color {
            switch self {
            case .default, .loading:
                    .defaultPrimary
            case .disabled:
                    .defaultBackground
            }
        }
        
        var textColor: Color {
            switch self {
            case .default, .loading:
                    .white
            case .disabled:
                    .default
            }
        }
        
        var isDisable: Bool {
            self == .disabled || self == .loading
        }
    }
    
    let text: String
    var buttonState: MainButtonState = .default
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
                        .font(.pretendard(size: 18, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56)
        }
        .background(buttonState.backgroundColor)
        .disabled(buttonState.isDisable)
        .cornerRadius(8)
    }
}

#Preview {
    MainButton(text: "Test")
}
