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
    let rank: Int
    
    var progessBarColor: Color {
        switch rank {
        case 1:
            return .green300
        case 2:
            return .green100
        default:
            return .green100
        }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .frame(height: 37)
                    .foregroundStyle(.pawkeyWhite2)
                
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: proxy.size.width * rating, height: 37)
                        .foregroundStyle(progessBarColor)
                        .frame(height: 37)
                }
                Text(title)
                    .font(.caption_12_sb)
                    .foregroundStyle(.pawkeyBlack)
                    .frame(height: 37, alignment: .center)
                    .padding(.leading, 13)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    ReviewRatingBar(title: "후기 옵션 입력", rating: 0.8, rank: 1)
}
