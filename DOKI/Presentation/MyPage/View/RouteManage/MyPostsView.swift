//
//  MyPostsView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MyPostsView: View {
    @ObservedObject var viewModel: MyPostsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.posts, id: \.postId) { post in
                    RouteCell(post: post) {
                        viewModel.toggleLike(post.postId)
                    }
                    .onTapGesture {
                        viewModel.navigationAction?(post.postId)
                    }
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
            Text("내가 기록한 산책")
                .subtitle()
        })
        .onAppear {
            viewModel.fetchMyPosts()
        }
    }
}

