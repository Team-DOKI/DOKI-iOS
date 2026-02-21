//
//  DBTIResultCard.swift
//  DOKI
//
//  Created by 안치욱 on 2/16/26.
//

import SwiftUI

struct DBTIResultCard: View {
    let dbtiName: String
    let type: String
    let imageUrl: String?
    let keywords: [String]
    let description: String
    let analysis: [AxisAnalysisData]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("내 강아지의 성향은")
                .bodyActive(color: .defaultDark)
                .padding(.top, 32)
            
            Text(dbtiName)
                .header2()
                .padding(.top, 16)
            
            Text(type)
                .header1(color: .defaultPrimary)
                .padding(.bottom, 20)
            
            // 이미지로 변경
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 150, height: 150)
            
            HStack(spacing: 8) {
                ForEach(keywords, id: \.self) { keyword in
                    Text("#\(keyword)")
                        .subActive(color: .defaultPrimary)
                        .padding(8)
                        .background(.primaryGra1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.top, 24)
            
            Text(description)
                .bodyActive()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
                .padding(.top, 24)
            
            VStack(spacing: 16) {
                ForEach(analysis) { data in
                    AxisScoreRow(data: data)
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 20)
            .padding(.bottom, 32)
        }
        .background(.defaultBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
