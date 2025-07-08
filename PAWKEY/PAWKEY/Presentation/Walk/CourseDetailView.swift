//
//  CourseDetailView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct CourseDetailView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            Rectangle()
                .fill(Color.pawkeyWhite2)
                .frame(height: 186)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24)
            
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text("제목 제목 제목")
                        .font(.head_20_sb)
                        .foregroundColor(.green500)
                    
                    Image(.eyeFill)
                }
                .padding(.bottom, 24)
                
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 43, height: 43)
                    
                    Text("rkddkwldlfma")
                        .font(.body_16_sb)
                        .foregroundColor(.pawkeyBlack)
                    
                }
                .padding(.bottom, 24)
                
                HStack(alignment: .center) {
                    Image(.locationGreen)
                    Text("강남구 역삼동")
                        .font(.body_14_m)
                        .foregroundColor(.gray400)
                }
                .padding(.bottom, 10)
                
                HStack(alignment: .center) {
                    Image(.clockGreen)
                    Text("2025.07.08(화) | 오후 11:28")
                        .font(.body_14_m)
                        .foregroundColor(.gray400)
                }
                .padding(.bottom, 12)
                
                Text("옵션")
                    .font(.body_14_m)
                    .foregroundStyle(.gray200)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.pawkeyWhite2)
                    .cornerRadius(4)
                    .padding(.bottom, 12)
                
                HStack(spacing: 6) {
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100)
                        .cornerRadius(4)
                }
                
                Text("gnrlgrnlg")
                    .font(.body_14_r)
                    .foregroundStyle(.pawkeyBlack)
                    .padding(.bottom, 12)
                
                Text("gnrlgrnlg")
                    .font(.caption_12_sb)
                    .foregroundStyle(.gray200)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color.pawkeyWhite2)
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("이런 점이 좋았어요")
                        .font(.head_18_sb)
                        .foregroundStyle(.pawkeyBlack)

                    Image(.editIconGray)
                    
                    Text("이런 점이 좋았어요")
                        .font(.caption_12_m)
                        .foregroundStyle(.gray200)
                }
                .padding(.bottom, 28)
                
                ReviewRatingBar(title: "후기", rating: 0.6, rank: 1)
                ReviewRatingBar(title: "후기", rating: 0.3, rank: 2)
                ReviewRatingBar(title: "후기", rating: 0.2, rank: 3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
        .topNavigationView(left: {
            Image(.arrowUpBlack)
        }, center: {
            Text("냐냐")
                .font(.body_16_sb)
        })
    }
}
