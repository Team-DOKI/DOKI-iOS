//
//  BreedItem.swift
//  PAWKEY
//
//  Created by 권석기 on 9/12/25.
//

import SwiftUI

struct BreedItem: View {
    let text: String
    let isChecked: Bool
    var action: (() -> Void)?
    
    var backgroundColor: Color {
        isChecked ? .green300 : .white
    }
    
    var textColor: Color {
        isChecked ? .white : .black
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            Text(text)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .foregroundStyle(textColor)
                .font(.pretendard(size: 14, weight: .regular))
                .padding(.leading, 16)
                .background(backgroundColor)
                .cornerRadius(8)
        }
        
    }
}

#Preview {
    BreedItem(text: "말라뮤트", isChecked: true)
}
