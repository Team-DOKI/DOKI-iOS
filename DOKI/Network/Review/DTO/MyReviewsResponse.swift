//
//  MyReviewsResponse.swift
//  DOKI
//
//  Created by 이세민 on 3/2/26.
//

struct MyReviewsResponse: Codable {
    let posts: [ReviewPosts]
}

struct ReviewPosts: Codable {
    let postId: Int
    let title: String
    let regionName: String
    let date: String
    let categoryOptionSummary: [String]
}
