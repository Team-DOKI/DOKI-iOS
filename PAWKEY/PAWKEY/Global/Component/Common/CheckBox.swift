//
//  CheckBox.swift
//  PAWKEY
//
//  Created by 권석기 on 9/12/25.
//

import SwiftUI

struct CheckBox: View {
    let text: String
    var isChecked: Bool = false
    var action: (() -> Void)? = nil
    
    var borderColor: Color {
        isChecked ? .defaultPrimary : .defaultMiddle
    }
    
    var textColor: Color {
        isChecked ? .defaultBackground : .defaultMiddle
    }
    
    var backgroundColor: Color {
        isChecked ? .defaultPrimary : .defaultBackground
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            VStack {
                Text(text)
                    .font(.pretendard(size: 14, weight: .regular))
                    .foregroundStyle(textColor)
            }
            .frame(maxWidth: .infinity, minHeight: 54)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedCorner(radius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
        }

    }
}

#Preview {
    CheckBox(text: "남아", isChecked: false)
}
