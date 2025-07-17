//
//  WalkPostDetailResponseDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

struct PostResponseDTO: Codable {
    let postId: Int
    let routeId: Int
    let title: String
    let content: String
    let isLike: Bool
    let authorInfo: AuthorInfoDTO
    let categoryTags: CategoryTagsDTO
    let regionName: String
    let createdAt: String
    let routeMapImageUrl: String
    let walkingImageUrls: [String]
}

struct AuthorInfoDTO: Codable {
    let authorId: Int
    let petId: Int
    let petName: String
    let petProfileImage: String
}

struct CategoryTagsDTO: Codable {
    let categoryOptionSummary: [String]
}

extension PostResponseDTO {
    func toEntity() -> Post {
        return Post(
            id: postId,
            routeId: routeId,
            title: title,
            content: content,
            isLiked: isLike,
            author: Author(
                id: authorInfo.authorId,
                petId: authorInfo.petId,
                petName: authorInfo.petName,
                petProfileImage: authorInfo.petProfileImage
            ),
            tags: categoryTags.categoryOptionSummary,
            region: regionName,
            createdDate: createdAt.toFormattedDateTimeString() ?? createdAt,
            routeImageUrl: routeMapImageUrl,
            walkingImageUrls: walkingImageUrls
        )
    }
}
