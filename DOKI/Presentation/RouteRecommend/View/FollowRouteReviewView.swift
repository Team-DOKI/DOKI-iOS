//
//  FollowRouteReviewView.swift
//  DOKI
//
//  Created by 이세민 on 3/13/26.
//

import SwiftUI

// TODO: - 구현 필요 (임시)
struct FollowRouteReviewView: View {
    @StateObject var viewModel: FollowRouteReviewViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            Text("루트 후기 남기기")
                .font(.title2)
                .bold()
            
            TextField("후기를 작성해주세요", text: $viewModel.reviewText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 20)
            
            Button {
                viewModel.completeReview()
            } label: {
                Text("작성 완료")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
