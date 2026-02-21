//
//  DBTIQuestion.swift
//  DOKI
//
//  Created by 안치욱 on 2/11/26.
//

import SwiftUI

struct DBTIQuestion: View {
    let data: DBTIQuestionData
    
    @Binding var selectedIndex: Int?
    
    var body: some View {
        VStack(spacing: 68) {
            VStack(spacing: 5) {
                Text(data.title)
                    .bodyActive(color: .defaultPrimary)
                
                Text(data.question)
                    .header3()
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 8) {
                ForEach(data.options.indices, id: \.self) { index in
                    let option = data.options[index]
                    
                    DBTIOptionCard(
                        title: option.content,
                        imageUrl: option.imageUrl,
                        isSelected: selectedIndex == index
                    ) {
                        selectedIndex = index
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 69)
    }
}
