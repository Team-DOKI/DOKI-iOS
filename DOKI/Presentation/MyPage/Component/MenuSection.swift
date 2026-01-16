//
//  MenuSection.swift
//  DOKI
//
//  Created by a on 1/12/26.
//

import SwiftUI

struct MenuSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .small(color: .defaultDark)
                    .frame(height: 38)
                
                Spacer()
            }
            
            content()
        }
        .padding(.horizontal, 16)
        .background(.defaultBackground)
        .cornerRadius(8)
    }
}
