//
//  MyReviewView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MyReviewView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.defaultBright.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(1...10, id: \.self) { _ in
                        ReviewCell(
                            title: "TITLE",
                            address: "상세 주소",
                            recordDate: "YY.MM.DD",
                            tags: ["혼잡도 보통", "교류 활발", "보도/차도 분리", "보도 넒음", "벤치", "배변 봉투 쓰레기통", "잔디길"]
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
            .topNavigationView(left: {
                BackButton(action: {
                    dismiss()
                })
            }, center: {
                Text("내가 남긴 후기")
                    .subtitle()
            })
    }
}

#Preview {
    MyReviewView()
}
