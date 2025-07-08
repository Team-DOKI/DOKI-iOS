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
        VStack(spacing: 32) {
            Text("산책 완료!").font(.largeTitle).bold()
            
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
            .padding(.top, 16)
            .padding(.horizontal, 23)
            
            Spacer()
        }
        .padding()
    }
}
