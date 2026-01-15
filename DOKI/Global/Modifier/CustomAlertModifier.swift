//
//  CustomAlertModifier.swift
//  DOKI
//
//  Created by a on 1/11/26.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    let image: Image?
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
                
                CustomAlertView(
                    image: image,
                    message: message,
                    subMessage: subMessage,
                    primaryTitle: primaryTitle,
                    secondaryTitle: secondaryTitle,
                    primaryAction: {
                        isPresented = false
                        primaryAction()
                    },
                    secondaryAction: {
                        isPresented = false
                        secondaryAction()
                    }
                )
            }
        }
    }
}

struct CustomAlertView: View {
    let image: Image?
    let message: String
    let subMessage: String?
    let primaryTitle: String
    let secondaryTitle: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .padding(.top, 24)
            }
            
            Text(message)
                .mainActive()
                .padding(.top, 34)
            
            if let subMessage {
                Text(subMessage)
                    .bodySmall(color: .defaultMiddle)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            
            HStack(spacing: 8) {
                MainButton(text: primaryTitle, buttonState: .disabled,  action: {})
                    .onTapGesture {
                        primaryAction()
                    }
                MainButton(text: secondaryTitle, action: secondaryAction)
            }
            .padding(.top, 34)
        }
        .padding(16)
        .background(.white)
        .cornerRadius(16)
        .padding(.horizontal, 19)
    }
}

extension View {
    func customAlert(
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
            CustomAlertModifier(
                image: image,
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
