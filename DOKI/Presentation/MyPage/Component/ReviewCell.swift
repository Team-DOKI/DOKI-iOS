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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .mainActive()

                Spacer()
            }
            .padding(.bottom, 12)

            Label(title: {Text(address)}, icon: {Image(.icMarker)})
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)
                .padding(.bottom, 4)

            Label(title: {Text(recordDate)}, icon: {Image(.icTimeclock)})
                .font(.bodyActive)
                .foregroundStyle(.defaultDark)

            Spacer().frame(height: 18)

            CollapsibleTagGrid(
                availableWidth: UIScreen.main.bounds.width - 70,
                data: tags,
                spacing: 8
            ) { tag in
                Text(tag.formattedCategoryTag())
                    .subActive(color: .defaultPrimary)
                    .padding(8)
                    .background(.primaryGra1)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(.defaultBackground)
        .cornerRadius(16)
        .overlay(
            RoundedCorner(radius: 16)
                .stroke(.defaultPrimary, lineWidth: 1)
        )
    }
}
