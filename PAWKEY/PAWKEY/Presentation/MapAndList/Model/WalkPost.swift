//
//  WalkPost.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

struct WalkPost: Hashable {
    let postId: Int
    let createdAt: String
    var isLike: Bool
    let title: String
    let routeId: Int
    let representativeImageUrl: String
    let writer: PostWriter
    let descriptionTags: [String]
}

struct PostWriter: Hashable {
    let userId: Int
    let petName: String
    let petProfileImageUrl: String
}
