//
//  MyCourseDTO.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//


import Foundation

struct MyCourseListDTO: Codable {
    let posts: [MyCourseDTO]
}

struct MyCourseDTO: Codable {
    let postId: Int
    let createdAt: String
    let isLike: Bool
    let title: String
    let representativeImageUrl: String
    let routeId: Int
    let writer: WriterDTO
    let descriptionTags: [String]
    let isPublic: Bool
}
