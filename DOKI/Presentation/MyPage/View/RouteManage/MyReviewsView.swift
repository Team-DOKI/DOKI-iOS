//
//  MyReviewsView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MyReviewsView: View {
    @ObservedObject var viewModel: MyReviewsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.defaultBright.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.reviews) { review in
                        ReviewCell(
                            title: review.title,
                            address: review.address,
                            recordDate: "review.date",
                            tags: review.tags
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
        .onAppear {
            viewModel.fetchMyReviews()
        }
    }
}
