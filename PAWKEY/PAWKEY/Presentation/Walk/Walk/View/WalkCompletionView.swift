//
//  WalkCompletionView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct WalkCompletionView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    
    let distance: Double
    let elapsedTime: String
    let stepCount: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("산책 완료!")
                .font(.title)
                .bold()
                .padding(.bottom, 33)
            
            Text("포비와 함께한 산책 루트에요.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 28)
            
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 43, height: 43)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("포비")
                        .font(.headline)
                    Text("2025.06.26 (금) | 오후 11:50")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 22)
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 156)
                .cornerRadius(8)
                .padding(.bottom, 10)
            
            HStack(spacing: 32) {
                StatView(title: "거리 (km)", value: String(format: "%.1f", distance))
                StatView(title: "시간 (분)", value: elapsedTime)
                StatView(title: "걸음 수 (걸음)", value: "\(stepCount)")
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity, minHeight: 84)
            .background(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.09, green: 0.74, blue: 0.18), lineWidth: 1)
            )
            
            Spacer()
        }
        .padding()
    }
}
