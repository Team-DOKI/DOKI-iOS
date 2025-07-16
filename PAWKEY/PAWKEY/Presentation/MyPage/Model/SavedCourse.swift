//
//  SavedCourse.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//

import Foundation

struct SavedCourse: Identifiable, Hashable {
    let id: Int
    let createdAt: String
    let isLiked: Bool
    let title: String
    let imageUrl: String
    let routeId: Int
    let petName: String
    let petImageUrl: String
    let tags: [String]
}

extension SavedCourse {
    init(dto: SavedCourseDTO) {
        self.id = dto.postId
        self.createdAt = Self.formatDateWithISO8601(dto.createdAt)
        self.isLiked = dto.isLike
        self.title = dto.title
        self.imageUrl = dto.representativeImageUrl
        self.routeId = dto.routeId
        self.petName = dto.writer.petName
        self.petImageUrl = dto.writer.petProfileImageUrl
        self.tags = dto.descriptionTags
    }
    
    static func formatDateWithISO8601(_ dateString: String) -> String {
        let dateComponent = String(dateString.prefix(10))
        return dateComponent.replacingOccurrences(of: "-", with: "/")
    }

}
