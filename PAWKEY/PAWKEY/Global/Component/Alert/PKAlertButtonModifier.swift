//
//  PKAlertButtonModifier.swift
//  PAWKEY
//
//  Created by 권석기 on 7/5/25.
//

import SwiftUI

struct PKAlertButtonModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    let alert: PKAlertView
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.black.opacity(0.75).ignoresSafeArea(.all)
                    alert
                        .padding(.horizontal, 30)
                }
                .background(ClearBackground())
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
    }
}

struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            superview?.superview?.backgroundColor = .clear
        }
        
    }
}

extension View {
    func pkAlertView(isPresented: Binding<Bool>, alert: @escaping () -> PKAlertView) -> some View {
        modifier(PKAlertButtonModifier(isPresented: isPresented, alert: alert()))
    }
}
