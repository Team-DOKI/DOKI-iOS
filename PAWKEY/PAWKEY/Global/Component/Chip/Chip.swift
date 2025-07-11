//
//  Chip.swift
//  PAWKEY
//
//  Created by 권석기 on 7/7/25.
//

import SwiftUI

struct Chip: View {
    let title: String
    var isActive: Bool = false
    
    var body: some View {
        Text(title)
            .font(.caption_12_r)
            .foregroundStyle(isActive ? .green600 : .pawkeyBlack)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isActive ? .green50 : .pawkeyWhite2)
            .clipShape(Capsule())
    }
}

#Preview {
    ZStack {
        Color.gray
        Chip(title: "옵션1", isActive: true)
    }
}
