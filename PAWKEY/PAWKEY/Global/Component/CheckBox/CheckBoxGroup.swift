//
//  CheckBoxGroup.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct CheckBoxGroup: View {
    @Binding var isExpanded: Bool
    
    let title: String
    
    var items: [CheckItem]
    var action: ((Int) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {                      
            HStack {
                let itemCount = items.filter{ $0.isSelected}.count
                Text(title)
                    .font(.body_16_sb)                    
                Spacer()
                if itemCount > 0 {
                    Text("\(itemCount)개 항목 선택")
                        .font(.caption_12_sb)
                        .foregroundStyle(.green)
                }
                Image(.arrowDownBlack)
                    .rotationEffect(isExpanded ? .degrees(-180) : .degrees(0))
            }
            .frame(height: 64)
            .padding(.horizontal, 16)
            .background(.white)
            .onTapGesture {
                isExpanded.toggle()
            }
            if isExpanded {
                VStack {
                    ForEach(Array(items.enumerated()), id: \.offset) { offset, item in
                        CheckBoxCell(title: item.title, isSelected: item.isSelected)
                            .onTapGesture {
                                action?(offset)
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
            Divider()
                .animation(nil)
        }

        .animation(isExpanded ? .easeInOut(duration: 0.2) : nil)
    }
}
