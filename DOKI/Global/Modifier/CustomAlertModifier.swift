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
    let subMessage: String
    let secondaryTitle: String?
    let primaryTitle: String
    let secondaryAction: (() -> Void)?
    let primaryAction: () -> Void
    
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
                    secondaryTitle: secondaryTitle,
                    primaryTitle: primaryTitle,
                    secondaryAction: {
                        isPresented = false
                        secondaryAction?()
                    },
                    primaryAction: {
                        isPresented = false
                        primaryAction()
                    }
                )
            }
        }
    }
}

struct CustomAlertView: View {
    let image: Image?
    let message: String
    let subMessage: String
    let secondaryTitle: String?
    let primaryTitle: String
    let secondaryAction: (() -> Void)?
    let primaryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .padding(.top, 20)
            }
            
            Text(message)
                .mainActive()
                .padding(.top, 34)
            
            Text(subMessage)
                .bodySmall(color: .defaultMiddle)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            HStack(spacing: 8) {
                if let secondaryTitle, let secondaryAction {
                    Button {
                        secondaryAction()
                    } label: {
                        Text(secondaryTitle)
                            .foregroundStyle(.defaultDark)
                            .font(.subtitle)
                    }
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(.defaultButton)
                    .cornerRadius(8)
                }
                
                Button {
                    primaryAction()
                } label: {
                    Text(primaryTitle)
                        .foregroundStyle(.defaultBackground)
                        .font(.subtitle)
                }
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(.defaultPrimary)
                .cornerRadius(8)
            }
            .padding(.top, 34)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(.defaultBackground)
        .cornerRadius(16)
        .padding(.horizontal, 19)
    }
}

extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        image: Image? = nil,
        message: String,
        subMessage: String,
        secondaryTitle: String? = nil,
        primaryTitle: String,
        secondaryAction: (() -> Void)? = nil,
        primaryAction: @escaping () -> Void
    ) -> some View {
        modifier(
            CustomAlertModifier(
                image: image,
                message: message,
                subMessage: subMessage,
                secondaryTitle: secondaryTitle,
                primaryTitle: primaryTitle,
                secondaryAction: secondaryAction,
                primaryAction: primaryAction,
                isPresented: isPresented
            )
        )
    }
}
