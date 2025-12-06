//
//  ContextMenuModifier.swift
//  PAWKEY
//
//  Created by 권석기 on 7/10/25.
//

import SwiftUI

struct ContextMenuModifier<CustomView: View>: ViewModifier {
    @Binding var isPresented: Bool
    
    let contentView: () -> CustomView
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.black.opacity(0.75).ignoresSafeArea(.all)
                        .onTapGesture {
                            isPresented = false
                        }
                    contentView()
                }
                .background(ClearBackgroundView())
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
    }
}

struct ClearBackgroundView: UIViewRepresentable {
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
    func contextMenu<CustomView: View>(isPresented: Binding<Bool>, content: @escaping () -> CustomView) -> some View {
        modifier(ContextMenuModifier(isPresented: isPresented, contentView: content))
    }
}
