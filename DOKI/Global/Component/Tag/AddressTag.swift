//
//  AddressTag.swift
//  PAWKEY
//
//  Created by 권석기 on 9/21/25.
//

import SwiftUI

struct AddressTag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.pretendard(size: 10, weight: .medium))
            .foregroundStyle(.defaultBackground)
            .padding(.vertical, 5)
            .padding(.horizontal, 6)
            .background(.defaultPrimary)
            .cornerRadius(4)
    }
}

#Preview {
    AddressTag(text: "강남구 역삼동")
}
