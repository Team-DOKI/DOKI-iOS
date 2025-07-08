//
//  AccordionView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct AccordionView: View {
    @Binding var isExpanded: Bool
    let title: String
    let items: [String]
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.body_16_sb)
                Spacer()
                Image(.arrowDownBlack)
                    .rotationEffect(isExpanded ? .degrees(-180) : .degrees(0))
            }
            .background(.white)
            .animation(.easeIn(duration: 0.2))
            .frame(height: 64)
            .onTapGesture {
                isExpanded.toggle()
            }
            if isExpanded {
                VStack {
                    ForEach(items, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .animation(isExpanded ? .default : nil)
        .padding(.horizontal, 16)
        
    }
}

#Preview {
    AccordionView(isExpanded: .constant(true), title: "산책 소요 시간", items: ["20분 이내", "21-40분", "41-60분", "1시간 이상"])
}
