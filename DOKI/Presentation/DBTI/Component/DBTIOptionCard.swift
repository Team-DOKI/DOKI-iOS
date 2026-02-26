//
//  DBTIOptionCard.swift
//  DOKI
//
//  Created by 안치욱 on 2/12/26.
//

import SwiftUI

struct DBTIOptionCard: View {
    let title: String
    let imageUrl: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 25) {
                if let imageUrl,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 90, height: 90)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 90, height: 90)
                }
                
                Text(title)
                    .font(isSelected ? .bodyActive : .bodyDefault)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isSelected ? .defaultPrimary : .contents)
            }
            .padding(.vertical, 38)
            .frame(width: 168)
            .background(isSelected ? .opacity5 : .defaultBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .defaultPrimary : .defaultMiddle)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
