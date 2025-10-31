//
//  TopNavigationViewModifier.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct TopNavigationViewModifier<C, L, R>: ViewModifier where C: View, L: View, R: View {
    let center: (() ->C)?
    let left: (() -> L)?
    let right: (() -> R)?
    
    init(center: (() -> C)? = {EmptyView()},
         left: (()-> L)? = {EmptyView()},
         right: (()-> R)? = {EmptyView()}) {
        self.center = center
        self.left = left
        self.right = right
    }
    
    func body(content: Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    left?()
                    Spacer()
                    right?()
                }
                .frame(minHeight: 60, maxHeight: 60)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .background(.white)
                
                HStack {
                    Spacer()
                    center?()
                    Spacer()
                }
            }            
            Spacer()
            content
            Spacer()
        }
        .navigationBarHidden(true)    
    }
}

extension View {
    func topNavigationView<C, L, R> (
        left: @escaping (() -> C),
        center: @escaping (() -> L),
        right: @escaping (() -> R)
    ) -> some View where C: View, L: View, R: View {
        modifier(TopNavigationViewModifier(center: center, left: left, right: right))
    }
    
    func topNavigationView<C, R> (
        center: @escaping (() -> C),
        right: @escaping (() -> R)
    ) -> some View where C: View, R: View {
        modifier(TopNavigationViewModifier(center: center, right: right))
    }
    
    func topNavigationView<C, L> (
        left: @escaping (() -> C),
        center: @escaping (() -> L)
    ) -> some View where C: View, L: View {
        modifier(TopNavigationViewModifier(center: center, left: left))
    }
    
    func topNavigationView<L> (
        left: @escaping (() -> L)
    ) -> some View where L: View {
        modifier(TopNavigationViewModifier(left: left))
    }
    
    func topNavigationView<R> (
        right: @escaping (() -> R)
    ) -> some View where R: View {
        modifier(TopNavigationViewModifier(right: right))
    }
    
    func topNavigationView<C> (
        center: @escaping (() -> C)
    ) -> some View where C: View {
        modifier(TopNavigationViewModifier(center: center))
    }
}
