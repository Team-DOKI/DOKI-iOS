//
//  PostMapper.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

extension Array where Element == Post {
    func toEntities() -> [PostItem] {
        map {
            PostItem(
                postId: $0.postId,
                regionName: $0.regionName,
                title: $0.title,
                date: $0.date,
                isLiked: $0.isLiked,
                imageUrl: $0.imageUrl,
                durationMinutes: $0.durationMinutes
            )
        }        
    }
}
