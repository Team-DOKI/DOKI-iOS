//
//  CustomModalModifier.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct CustomModalModifier<ModalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let modalContent: () -> ModalContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.8)
                    .ignoresSafeArea(.all)
                    .transition(.opacity)
                
                modalContent()
            }
        }
    }
}

extension View {
    func customModal<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            CustomModalModifier(
                isPresented: isPresented,
                modalContent: content
            )
        )
    }
}
