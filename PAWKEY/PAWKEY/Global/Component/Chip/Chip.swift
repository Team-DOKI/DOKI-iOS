//
//  Chip.swift
//  PAWKEY
//
//  Created by 권석기 on 7/7/25.
//

import SwiftUI

struct Chip: View {
    let title: String
    var isActive: Bool = true
 //   var textColor: Color = Color.pawkeyBlack
    var textColor: Color?
    
    var body: some View {
        Text(title)
            .font(.caption_12_r)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(textColor ?? (isActive ? .green600 : .pawkeyBlack))
            .background(isActive ? .green50 : .pawkeyWhite2)
            .clipShape(Capsule())
            
    }
}

#Preview {
    ZStack {
        Color.gray
        Chip(title: "옵션1asdfsadfsdf", isActive: true)
    }
}
