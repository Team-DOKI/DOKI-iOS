//
//  WalkPostResponseDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

struct PostDataDTO: Codable {
    let posts: [PostDTO]
}

struct PostDTO: Codable {
    let postId: Int
    let createdAt: String
    let isLike: Bool
    let title: String
    let routeId: Int
    let representativeImageUrl: String
    let writer: WriterDTO
    let descriptionTags: [String]
}

struct WriterDTO: Codable {
    let userId: Int
    let petName: String
    let petProfileImageUrl: String
}
