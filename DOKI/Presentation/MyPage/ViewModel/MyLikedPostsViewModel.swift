//
//  MyLikedPostsViewModel.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import SwiftUI

class MyLikedPostsViewModel: ObservableObject {
    @Published var posts: [RouteInfo] = []
    private let routeAPIService: RouteAPIServiceProtocol
    
    init(routeAPIService: RouteAPIServiceProtocol = RouteAPIService()) {
        self.routeAPIService = routeAPIService
    }
    
    func fetchMyLikedPosts() {
        routeAPIService.fetchMyLikedPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.posts = response?.data?.posts.map { post in
                        RouteInfo(
                            id: post.postId,
                            title: post.title,
                            address: post.regionName,
                            date: post.date.formattedToYYMMDD(),
                            duration: post.durationMinutes.formattedDuration(),
                            isLiked: post.isLiked,
                            imageURL: post.imageUrl
                        )
                    } ?? []
                default:
                    print("좋아요 한 게시글 불러오기에 실패했습니다.")
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
                        if let index = self?.posts.firstIndex(where: { $0.id == postId }) {
                            self?.posts[index].isLiked = true
                        }
                    } else if status == "CANCEL_SUCCESS" {
                        if let index = self?.posts.firstIndex(where: { $0.id == postId }) {
                            self?.posts.removeAll { $0.id == postId }
                        }
                    }
                default:
                    print("좋아요 토글에 실패했습니다.")
                }
            }
        }
    }
}
