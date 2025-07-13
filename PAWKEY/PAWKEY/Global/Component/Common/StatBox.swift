//
//  StatBox.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI

struct StatBox: View {
    enum BoxType {
        case bordered
        case borderless
    }
    
    let type: BoxType
    let distance: Double
    let elapsedTime: String
    let stepCount: Int
    
    var body: some View {
        HStack(spacing: 32) {
            VStack(spacing: 6) {
                Text("거리 (km)")
                    .font(.caption_12_sb)
                    .foregroundColor(.gray500)
                
                Text(String(format: "%.1f", distance))
                    .font(.head_20_b)
                    .foregroundColor(.green500)
            }
            .frame(width: 67, height: 42)
            
            VStack(spacing: 6) {
                Text("시간 (분)")
                    .font(.caption_12_sb)
                    .foregroundColor(.gray500)
                
                Text(elapsedTime)
                    .font(.head_20_b)
                    .foregroundColor(.green500)
            }
            .frame(width: 67, height: 42)
            
            VStack(spacing: 6) {
                Text("걸음 수 (걸음)")
                    .font(.caption_12_sb)
                    .foregroundColor(.gray500)
                
                Text("\(stepCount)")
                    .font(.head_20_b)
                    .foregroundColor(.green500)
            }
            .frame(width: 67, height: 42)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, minHeight: 74)
        .background(Color.pawkeyWhite1)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(type == .bordered ? Color.green500 : Color.clear, lineWidth: 1)
        )
    }
}
