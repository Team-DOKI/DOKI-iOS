//
//  TotalWalkStatBox.swift
//  DOKI
//
//  Created by 이세민 on 1/10/26.
//

import SwiftUI

struct TotalWalkStatBox: View {
    var distance: Double
    var totalTime: String
    var count: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TotalWalkStatItem(title: "누적 거리", value: String(format: "%.1f KM", distance))
            
            Divider()
                .frame(height: 40)
                .background(.defaultPrimary)
            
            TotalWalkStatItem(title: "총 산책 시간", value: totalTime)
            
            Divider()
                .frame(height: 40)
                .background(.defaultPrimary)
            
            TotalWalkStatItem(title: "산책 횟수", value: "\(count) 회")
        }
        .padding(16)
        .background(.opacity5)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.defaultPrimary, lineWidth: 1)
        )
    }
}

struct TotalWalkStatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.bodyBold)
            
            Text(value)
                .font(.bodyActive)
        }
        .foregroundColor(.defaultPrimary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TotalWalkStatBox(
        distance: 12.4,
        totalTime: "05:32:10",
        count: 18
    )
}
