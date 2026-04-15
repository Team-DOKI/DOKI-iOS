//
//  MyPostsViewModel.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import SwiftUI

class MyPostsViewModel: ObservableObject {
    @Published var posts: [PostItem] = []
    var navigationAction: ((Int) -> ())?
    private let routeAPIService: RouteAPIServiceProtocol
    
    init(routeAPIService: RouteAPIServiceProtocol = RouteAPIService()) {
        self.routeAPIService = routeAPIService
    }
    
    func fetchMyPosts() {
        routeAPIService.fetchMyPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.posts = response?.data?.posts.map { post in
                        print("📷 post \(post.postId) imageUrl: \(post.imageUrl ?? "nil")")
                        return PostItem(
                            postId: post.postId,
                            regionName: post.regionName,
                            title: post.title,
                            date: post.date,
                            isLiked: post.isLiked,
                            imageUrl: post.imageUrl,
                            durationMinutes: post.durationMinutes
                        )
                    } ?? []
                default:
                    print("내 게시글 불러오기에 실패했습니다.")
                }
            }
        }
    }
    
    func toggleLike(_ postId: Int) {
        routeAPIService.toggleLike(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let status = response?.data?.status else { return }
                    if status == "LIKE_SUCCESS" {
                        if let index = self?.posts.firstIndex(where: { $0.postId == postId }) {
                            self?.posts[index].isLiked = true
                        }
                    } else if status == "CANCEL_SUCCESS" {
                        if let index = self?.posts.firstIndex(where: { $0.postId == postId }) {
                            self?.posts[index].isLiked = false
                        }
                    }
                default:
                    print("좋아요 실패")
                }
            }
        }
    }
}
