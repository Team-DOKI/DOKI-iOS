//
//  SegmentedButton.swift
//  DOKI
//
//  Created by a on 11/1/25.
//

import SwiftUI

struct SegmentedButton: View {
    let items: [String]
    @Binding var selectedItem: String
    @Namespace var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                ZStack {
                    if selectedItem == item {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.defaultPrimary)
                            .matchedGeometryEffect(id: "background", in: namespace)
                    }

                    Text(item)
                        .subDefault(color: selectedItem == item ? .defaultBackground : .default)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedItem = item
                    }
                }
            }
        }
        .background(.defaultButton)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxHeight: 40)
    }
}
