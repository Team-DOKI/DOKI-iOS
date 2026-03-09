//
//  MyLikedPostsView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MyLikedPostsView: View {
    @ObservedObject var viewModel: MyLikedPostsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.posts, id: \.id) { post in
//                    RouteCell(post: post) {
//                        viewModel.toggleLike(post.id)
//                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .topNavigationView(left: {
            BackButton(action: {
                dismiss()
            })
        }, center: {
            Text("저장목록")
                .subtitle()
        })
        .onAppear {
            viewModel.fetchMyLikedPosts()
        }
  
    }
}

