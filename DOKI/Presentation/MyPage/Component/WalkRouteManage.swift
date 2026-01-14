//
//  WalkRouteManage.swift
//  DOKI
//
//  Created by 안치욱 on 12/29/25.
//

import SwiftUI

struct WalkRouteManage: View {
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("산책 루트 관리")
                    .small(color: .defaultDark)
                Spacer()
            }
            .frame(height: 32)
            .padding(.horizontal, 16)
            
            Button {
                // 내가 기록한 산책
                print("내가 기록한 산책")
            } label: {
                HStack(spacing: 8) {
                    Image(.icRecord)
                    Text("내가 기록한 산책")
                        .bodyDefault()
                    Spacer()
                    Image(.btnMore)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .frame(height: 56)
            
            Button {
                // 저장목록
                print("저장목록")
            } label: {
                HStack(spacing: 8) {
                    Image(.icSave)
                    Text("저장목록")
                        .bodyDefault()
                    Spacer()
                    Image(.btnMore)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .frame(height: 56)
            
            Button {
                // 내가 남긴 후기
                print("내가 남긴 후기")
            } label: {
                HStack(spacing: 8) {
                    Image(.icReview)
                    Text("내가 남긴 후기")
                        .bodyDefault()
                    Spacer()
                    Image(.btnMore)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
            }
            .frame(height: 56)
        }
        .background(.defaultBackground)
        .cornerRadius(8)
    }
}
