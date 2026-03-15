//
//  PostResponse.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

import Foundation

struct PostResponse: Codable {
    let posts: [Post]
    let nextCursor: String?
    let hasNext: Bool
}

struct Post: Codable {
    let postId: Int
    let regionName: String
    let title: String
    let date: String
    let durationMinutes: Int
    let isLiked: Bool
    let imageUrl: String
}

struct ReviewResponse: Codable {
    let postId: Int
    let totalReviewCount: Int
    let categoryTop3: [CategoryTop]
}

extension ReviewResponse {
    
    struct CategoryTop: Codable {
        let categoryId: Int
        let categoryName: String
        let categoryOptionId: Int
        let optionText: String
        let rank: Int
        let percentage: Int
    }
}
