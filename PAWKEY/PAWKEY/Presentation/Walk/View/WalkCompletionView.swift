//
//  WalkCompletionView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct WalkCompletionView: View {
    @EnvironmentObject var router: Coordinator<WalkScreen>
    @EnvironmentObject var tabBarState: TabBarState
    
    let distance: Double
    let elapsedTime: String
    let stepCount: Int
    let snapshot: UIImage?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("산책 완료!")
                .font(.head_20_b)
                .foregroundColor(.pawkeyBlack)
                .padding(.top, 20)
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
            
            if let snapshot = snapshot {
                Image(uiImage: snapshot)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 156)
                    .cornerRadius(8)
                    .padding(.bottom, 10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 156)
                    .cornerRadius(8)
                    .padding(.bottom, 10)
            }
            
            StatBox(distance: distance, elapsedTime: elapsedTime, stepCount: stepCount)
              
            Spacer()
            
            CTAButton(
                title: "산책 기록하기",
                isDisabled: false,
                buttonStyle: .filled
            ) {
                router.push(.archive(snapshot: snapshot))
            }
            .padding(.bottom, 26)
        }
        .padding(.horizontal, 16)
        .onAppear {
            withAnimation {
                tabBarState.isHidden = true
            }
        }
    }
}
