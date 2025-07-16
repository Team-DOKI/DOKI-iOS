//
//  WalkPostDataMapper.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//


extension Array where Element == PostDTO {
    func toEntity() -> [WalkPost] {
        map {
            WalkPost(
                postId: $0.postId,
                createdAt: $0.createdAt,
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

