//
//  PostDetailResponse.swift
//  DOKI
//
//  Created by 권석기 on 3/15/26.
//

struct PostDetailResponse: Codable {
    let postId: Int
    let title: String
    let description: String
    let isPublic: Bool
    let isMine: Bool
    let hasReviewed: Bool
    let authorInfo: AuthorInfo
    let routeDisplay: RouteDisplay
    let categoryTagTexts: [String]
    let walkImages: [WalkImage]
}

extension PostDetailResponse {
    
    struct AuthorInfo: Codable {
        let authorId: Int
        let petId: Int
        let petName: String
        let petProfileImage: String
    }
    
    struct RouteDisplay: Codable {
        let routeId: Int
        let locationText: String
        let dateTimeText: String
        let metaTagTexts: [String]
        let routeImageUrl: String
    }
    
    struct WalkImage: Codable {
        let imageId: Int
        let imageUrl: String
    }
}
