//
//  CustomModalModifier.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct CustomModalModifier: ViewModifier {
    let message: String
    let subMessage: String?
    let primaryTitle: String
    let secondaryTitle: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                CustomModalView(
                    message: message,
                    subMessage: subMessage,
                    primaryTitle: primaryTitle,
                    secondaryTitle: secondaryTitle,
                    primaryAction: primaryAction,
                    secondaryAction: secondaryAction
                )
            }
        }
    }
}

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
                    buttonState: .disabled,
                    action: primaryAction,
                )
                .onTapGesture(perform: primaryAction)
                
                MainButton(
                    text: secondaryTitle,
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

extension View {
    func customModal(
        isPresented: Binding<Bool>,
        image: Image? = nil,
        message: String,
        subMessage: String? = nil,
        primaryTitle: String,
        secondaryTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) -> some View {
        modifier(
            CustomModalModifier(
                message: message,
                subMessage: subMessage,
                primaryTitle: primaryTitle,
                secondaryTitle: secondaryTitle,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction,
                isPresented: isPresented
            )
        )
    }
}
