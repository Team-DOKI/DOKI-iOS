//
//  ReviewTagButton.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/9/25.
//

import SwiftUI

struct ReviewTagButton: View {
    let title: String
    
    @Binding var isSelected: Bool
    
    var font : Font {
        isSelected ? .body_14_sb : .body_14_r
    }
    
    var fouregroundColor : Color {
        isSelected ? .green500 : .gray400
    }
    
    var borderColor : Color {
        isSelected ? Color.green500 : Color.gray50
    }
    
    var lineWidth: CGFloat {
        isSelected ? 2 : 1
    }
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text(title)
                .font(font)
                .foregroundColor(fouregroundColor)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: lineWidth)
                )
                .cornerRadius(8)
        }
    }
}

