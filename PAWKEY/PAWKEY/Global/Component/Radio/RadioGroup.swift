//
//  RadioGroup.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct RadioGroup: View {
    @Binding var isExpanded: Bool
    
    let title: String
    
    var items: [SelecteItem]
    var action: ((SelecteItem) -> Void)?
    var onTapGroup: (() -> ())?
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.body_16_sb)
                Spacer()
                if let selectedItem = items.filter({$0.isSelected}).first {
                    Text(selectedItem.selectText)
                        .font(.caption_12_sb)
                        .foregroundStyle(.green)
                }
                Image(.arrowDownBlack)
                    .rotationEffect(isExpanded ? .degrees(-180) : .degrees(0))
            }
            .background(.white)
            .frame(height: 64)
            .padding(.horizontal, 16)
            .onTapGesture {
                isExpanded.toggle()
                onTapGroup?()
            }
            if isExpanded {
                VStack {
                    ForEach(Array(items.enumerated()), id: \.offset) { offset, item in
                        RadioCell(checkOption: .init(title: item.selectText, isSelected: item.isSelected))
                            .onTapGesture {
                                action?(item)
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
