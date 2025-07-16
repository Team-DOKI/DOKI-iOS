//
//  SavedCourseDTO.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//

import Foundation

struct SavedCourseListDTO: Codable {
    let posts: [SavedCourseDTO]
}

struct SavedCourseDTO: Codable {
    let postId: Int
    let createdAt: String
    let isLike: Bool
    let title: String
    let representativeImageUrl: String
    let routeId: Int
    let writer: WriterDTO
    let descriptionTags: [String]
}

struct WriterDTO: Codable {
    let userId: Int
    let petName: String
    let petProfileImageUrl: String
}
