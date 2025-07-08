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
            .font(.pretendard(size: 14, weight: .medium))
            .foregroundStyle(isActive ? .black : .gray300)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.white)
            .cornerRadius(4)
    }
}

#Preview {
    ZStack {
        Color.gray
        Chip(title: "선택된 옵션 입력")
    }
}
