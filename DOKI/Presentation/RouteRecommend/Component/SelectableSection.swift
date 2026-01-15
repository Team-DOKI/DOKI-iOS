//
//  SelectableSection.swift
//  DOKI
//
//  Created by a on 11/14/25.
//

import SwiftUI

enum SelectionMode {
    case single
    case multiple
}

struct SelectableSection: View {
    let title: String
    var subtitle: String
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var selectionMode: SelectionMode = .multiple
    
    @Binding var items: [FilteringOption]
    
    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(
                title: title,
                subtitle: subtitle
            )
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        SelectButton(
                            text: items[index].text,
                            isActive: items[index].isActive
                        ) {
                            handleSelection(at: index)
                        }
                    }
                }
            }
        }
    }
    
    private func handleSelection(at index: Int) {
        switch selectionMode {
        case .single:
            for i in items.indices {
                items[i].isActive = (i == index)
            }
        case .multiple:
            items[index].isActive.toggle()
        }
    }
}

