//
//  OptionItem.swift
//  DOKI
//
//  Created by 권석기 on 9/12/25.
//

import SwiftUI

struct OptionItem: View {
    let text: String
    var isChecked: Bool = false
    var action: (() -> Void)?
    
    var backgroundColor: Color {
        isChecked ? .defaultPrimary : .defaultBackground
    }
    
    var textColor: Color {
        isChecked ? .defaultBackground : .contents
    }
    
    var font: Font {
        isChecked ? .bodyActive : .bodyDefault
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            Text(text)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .foregroundStyle(textColor)
                .font(font)
                .padding(.leading, 16)
                .background(backgroundColor)
                .cornerRadius(8)
        }
        
    }
}

#Preview {
    OptionItem(text: "말라뮤트", isChecked: true)
}
