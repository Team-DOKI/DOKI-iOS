//
//  WalkConfirmOverlay.swift
//  DOKI
//
//  Created by 이세민 on 1/10/26.
//

import SwiftUI

enum WalkConfirmType {
    case pause
    case finish
}

struct WalkConfirmOverlay: View {
    let title: String
    let message: String
    let leftButtonText: String
    let rightButtonText: String
    let onLeftAction: () -> Void
    let onRightAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.contents.opacity(0.75)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.header2)
                        .foregroundColor(.defaultBackground)
                    
                    Text(message)
                        .font(.subtitle)
                        .foregroundColor(.defaultBackground)
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack(spacing: 8) {
                    MainButton(
                        text: leftButtonText,
                        buttonState: .active2,
                        size: .medium,
                        action: onLeftAction
                    )
                    
                    MainButton(
                        text: rightButtonText,
                        buttonState: .active1,
                        size: .medium,
                        action: onRightAction
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
        }
        .transition(.opacity)
        .ignoresSafeArea()
    }
}
