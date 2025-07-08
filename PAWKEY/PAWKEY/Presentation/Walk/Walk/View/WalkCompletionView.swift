//
//  WalkCompletionView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct WalkCompletionView: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    @EnvironmentObject var tabBarState: TabBarState
    
    let distance: Double
    let elapsedTime: String
    let stepCount: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("산책 완료!")
                .font(.head_20_b)
                .foregroundColor(.pawkeyBlack)
                .padding(.bottom, 29)
            
            Text("포비와 함께한 산책 루트에요.")
                .font(.head_18_sb)
                .foregroundColor(.pawkeyBlack)
                .padding(.bottom, 24)
            
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 43, height: 43)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("포비")
                        .font(.body_16_sb)
                    Text("2025.06.26 (금) | 오후 11:50")
                        .font(.caption_12_r)
                        .foregroundColor(.gray300)
                }
                .padding(.bottom, 18)
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
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity, minHeight: 74)
            .background(.pawkeyWhite1)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(.green500, lineWidth: 1)
            )
            
            Spacer()
            
            CTAButton(
                title: "산책 기록하기",
                isDisabled: false,
                buttonStyle: .filled
            ) {
                router.push(.archive)
            }
            .padding(.bottom, 26)
        }
        .padding(.horizontal, 16)
        .onAppear {
            withAnimation {
                tabBarState.isHidden = true
            }
        }
        .onDisappear {
            withAnimation {
                tabBarState.isHidden = false
            }
        }
    }
}
