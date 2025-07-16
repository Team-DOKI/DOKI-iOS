//
//  WalkPostDataMapper.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

extension Array where Element == PostDTO {
    func toEntity() -> [WalkPost] {
        map {
            WalkPost(
                postId: $0.postId,
                createdAt: $0.createdAt.toFormattedDateString() ?? "",
                isLike: $0.isLike,
                title: $0.title,
                routeId: $0.routeId,
                representativeImageUrl: $0.representativeImageUrl,
                writer: $0.writer.toEntity(),
                descriptionTags: $0.descriptionTags
            )
        }
    }
}

extension WriterDTO {
    func toEntity() -> PostWriter {
        PostWriter(
            userId: userId,
            petName: petName,
            petProfileImageUrl: petProfileImageUrl
        )
    }
}

// Review data mapping

extension WalkPostReviewDTO {
    func toEntity() -> WalkPostSummary {
        return WalkPostSummary(
            postId: postId,
            totalReviewCount: totalReviewCount,
            categoryTop3: categoryTop3.map { $0.toEntity() }
        )
    }
}

extension CategoryTopDTO {
    func toEntity() -> CategoryTop {
        return CategoryTop(
            categoryId: categoryId,
            categoryName: categoryName,
            categoryOptionId: categoryOptionId,
            optionText: optionText,
            rank: rank,
            percentage: percentage
        )
    }
}
