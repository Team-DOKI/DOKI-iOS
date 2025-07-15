//
//  ArchiveDTO.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import Foundation

// Response
struct ArchiveInfoDTO: Codable {
    let routeDto: Route
    let petName: String
}

struct Route: Codable {
    let id: Int
    let locationDescription: String
    let dateDescription: String
    let descriptionTags: [String]
}

struct CategoryDTO: Codable {
    let categoryList: [CategoryList]
}

struct CategoryList: Codable {
    let categoryId: Int
    let categoryDescription: String
    let categoryOptions: [CategoryOptions]
}

struct CategoryOptions: Codable {
    let categoryOptionId: Int
    let categoryOptionText: String
}

// Request
struct ArchivePostDTO: Codable {
    let title: String
    let description: String
    let isPublic: Bool
    let selectedOptionsForCategories: [SelectedCategoryOptions]
    let routeId: Int
}

struct SelectedCategoryOptions: Codable {
    let categoryId: Int
    let selectedOptionIds: [Int]
}

// Response
struct ArchiveResponseDTO: Codable {
    let postId: Int
}
