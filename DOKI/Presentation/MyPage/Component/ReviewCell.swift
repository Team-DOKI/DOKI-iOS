//
//  ReviewCell.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct ReviewCell: View {
    let title: String
    let address: String
    let recordDate: String
    let tags: [String]
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .mainActive()
                
                Spacer()
            }
            
            Spacer().frame(height: 8)
            
            Label(title: {Text(address)}, icon: {Image(.icMarker)})
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
            
            Spacer().frame(height: 4)
            
            Label(title: {Text(recordDate)}, icon: {Image(.icTimeclock)})
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
            
            Spacer().frame(height: 18)
            
            // TODO: 코드 병합 후 컴포넌트 교체
            FlexibleGrid(
                availableWidth: UIScreen.main.bounds.width - 70,
                data: isExpanded ? tags : tags.prefix(4).map{ $0 },
                spacing: 8,
                alignment: .leading
            ) { tag in
                Text(tag)
                    .subActive(color: .defaultPrimary)
                    .padding(8)
                    .background(.primaryGra1)
                    .cornerRadius(8)
            }
            if !isExpanded {
                Spacer().frame(height: 11)
                HStack(spacing: 5) {
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)
                    
                    Text("+\(tags.count - 4)")
                        .bodySmall(color: .defaultMiddle)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .background(.defaultButton)
                        .clipShape(Capsule())
                        .onTapGesture {
                            isExpanded = true
                        }
                    
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.defaultButton)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(.defaultBackground)
        .cornerRadius(16)
        .overlay(
            RoundedCorner(radius: 16)
                .stroke(.defaultPrimary, lineWidth: 1)
        )
    }
}
