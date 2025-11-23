//
//  SelectableSection.swift
//  DOKI
//
//  Created by a on 11/14/25.
//

import SwiftUI

struct SelectableSection: View {
    let title: String
    let subtitle: String
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    @Binding var items: [FilteringOption]
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: title,
                subtitle: subtitle
            )
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach($items, id: \.self) { $filterOption in
                        SelectButton(text: filterOption.text, isActive: filterOption.isActive) {
                            filterOption.isActive.toggle()
                        }
                    }
                }
            }
        }
    }
}

