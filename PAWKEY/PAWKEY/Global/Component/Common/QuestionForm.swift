//
//  QuestionForm.swift
//  PAWKEY
//
//  Created by 이세민 on 7/12/25.
//

import SwiftUI

struct QuestionForm: View {
    let question: String
    let tags: [String]
    
    @Binding var selectedTags: Set<String>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question)
                .font(.body_16_m)
                .foregroundColor(.pawkeyBlack)
                .padding(.bottom, 12)
            
            FlexibleGrid(
                availableWidth: UIScreen.main.bounds.width - 32,
                data: tags,
                spacing: 8,
                alignment: .leading
            ) { tag in
                ReviewTagButton(
                    title: tag,
                    isSelected: Binding(
                        get: { selectedTags.contains(tag) },
                        set: { newValue in
                            if newValue {
                                selectedTags.insert(tag)
                            } else {
                                selectedTags.remove(tag)
                            }
                        }
                    )
                )
            }
        }
    }
}
