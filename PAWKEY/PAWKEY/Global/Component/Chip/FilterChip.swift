//
//  FilterChip.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    
    var body: some View {
        Text(title.isEmpty ? "선택된 옵션이 없어요" : title)
            .font(.body_14_r)
            .foregroundStyle(title.isEmpty ? .gray200 : .gray400)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 100.0).stroke(lineWidth: 1).foregroundStyle(.gray100)
            )
    }
}

#Preview {
    FilterChip(title: "21분~40분")
}
