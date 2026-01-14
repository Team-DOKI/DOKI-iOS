//
//  StatItem.swift
//  DOKI
//
//  Created by 이세민 on 12/12/25.
//

import SwiftUI

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.subActive)
                .foregroundColor(.defaultDark)
            
            Text(value)
                .font(.header3)
                .foregroundColor(.defaultPrimary)
        }
        .frame(width: 114)
    }
}

#Preview {
    StatItem(title: "거리 (km)", value: "2.2")
}
