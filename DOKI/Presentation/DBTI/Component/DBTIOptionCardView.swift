//
//  DBTIOptionCardView.swift
//  DOKI
//
//  Created by 안치욱 on 2/12/26.
//

import SwiftUI

struct DBTIOptionCardView: View {
    let option: DBTIOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 25) {
                AsyncImage(url: option.imageURL) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFit()
                    default:
                        Rectangle().opacity(0.06)
                    }
                }
                .frame(width: 90, height: 90)
                .padding(.top, 38)
                .padding(.horizontal, 39)

                Text(option.content)
                    .font(.bodyActive)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isSelected ? .defaultPrimary : .contents)
                    .padding(.bottom, 38)
            }
            .frame(width: 168, height: 231)
            .background(isSelected ? .defaultPrimary.opacity(0.05) : .white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .defaultPrimary : Color.gray.opacity(0.35), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
