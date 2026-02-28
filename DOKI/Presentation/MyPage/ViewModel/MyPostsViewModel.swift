//
//  MyPostsViewModel.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import SwiftUI

class MyPostsViewModel: ObservableObject {
    @Published var posts: [RouteInfo] = []
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
                    print("반려견 정보 수정에 실패했습니다.")
                }
            }
        }
    }
}
