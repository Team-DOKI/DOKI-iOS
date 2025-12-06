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
            .font(.small)
            .foregroundStyle(.defaultPrimary)
            .padding(.vertical, 5)
            .padding(.horizontal, 6)
            .background(.opacity5)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .inset(by: 0.5)
                    .stroke(.defaultPrimary, lineWidth: 1)
            )
    }
}

#Preview {
    AddressTag(text: "강남구 역삼동")
}
