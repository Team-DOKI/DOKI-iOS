//
//  ReviewRatingBar.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct ReviewRatingBar: View {
    let title: String
    let rating: Double
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 37)
                    .foregroundStyle(.pawkeyWhite2)
                
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: proxy.size.width * rating, height: 37)
                    .foregroundStyle(.green)
                Text(title)
                    .font(.caption_12_sb)
                    .frame(height: 37, alignment: .center)
                    .padding(.leading, 13)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    ReviewRatingBar(title: "후기 옵션 입력", rating: 0.8)
        .padding(.horizontal, 20)
}
