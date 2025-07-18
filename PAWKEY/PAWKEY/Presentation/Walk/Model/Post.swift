//
//  Post.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

struct Post {
    let id: Int
    let routeId: Int
    let title: String
    let content: String
    var isLiked: Bool
    let author: Author
    let tags: [String]
    let region: String
    let createdDate: String
    let routeImageUrl: String
    let walkingImageUrls: [String]
}

struct Author {
    let id: Int
    let petId: Int
    let petName: String
    let petProfileImage: String
}
