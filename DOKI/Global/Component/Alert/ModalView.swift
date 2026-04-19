//
//  ModalView.swift
//  DOKI
//
//  Created by 권석기 on 3/9/26.
//

import SwiftUI

struct CustomModalView: View {
    let message: String
    let subMessage: String?
    let primaryTitle: String
    let secondaryTitle: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 16)
            
            Text(message)
                .mainActive()
            
            Spacer().frame(height: 8)
            
            if let subMessage {
                Text(subMessage)
                    .bodyDefault(color: .defaultMiddle)
            }
            
            Spacer().frame(height: 16)
            
            HStack(spacing: 9) {
                MainButton(
                    text: primaryTitle,
                    buttonState: .normal,
                    size: .medium,
                    action: primaryAction,
                )
                .onTapGesture(perform: primaryAction)
                
                MainButton(
                    text: secondaryTitle,
                    size: .medium,
                    action: secondaryAction,
                )
            }
        }
        .padding(16)
        .background(.defaultBackground)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}
