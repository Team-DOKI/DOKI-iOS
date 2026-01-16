//
//  WalkResultView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkResultView: View {
    @StateObject var viewModel: WalkResultViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Circle()
                        .frame(width: 36, height: 36)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("단지")
                            .subtitle()
                        
                        HStack(spacing: 4) {
                            Text("2025.06.26(금)")
                            
                            Text("|")
                            
                            Text("2025.06.26(금)")
                        }
                        .font(.subDefault)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                
                Rectangle()
                    .foregroundColor(.defaultMiddle)
                    .cornerRadius(4)
                
                HStack(spacing: 0) {
                    RecordStatItem(title: "거리 (km)", value: "2.2")
                    RecordStatItem(title: "시간 (분)", value: "30:00")
                    RecordStatItem(title: "걸음 수 (걸음)", value: "12345")
                }
                .padding(.vertical, 14)
            }
            .padding(.horizontal, 16)
            .background(.defaultBackground)
            .cornerRadius(16)
            .padding(.top, 38)
            .padding(.bottom, 48)
            
            MainButton(text: "후기 작성하기", buttonState: .active1) {
                viewModel.navigateToWalkReview()
            }
        }
        .padding(.horizontal, 16)
        .background(.defaultBright)
        .topNavigationView(center: {
            Text("산책 완료")
                .subtitle()
        })
    }
}

#Preview {
    NavigationStack {
        WalkResultView(viewModel: WalkResultViewModel())
    }
}
