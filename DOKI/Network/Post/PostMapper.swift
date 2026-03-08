//
//  PostMapper.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

// PostResponse -> PostItem
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

// 데이터 조회시 필터링값 적용을위한 메서드
extension Array where Element == FilterList {
    func toDto() -> PostRequest {
        return PostRequest(selectedOption: self.map {
            // 서버에서는 duration, category 2개의 유형으로 받음
            // 클라에서는 소요시간을 제외하고 category 유형으로 설정하여 서버로 전송
            switch $0.filterType {
            case .duration:
                PostOption(durationId: $0.id,optionsIds: $0.options.filter { $0.isActive }.map { $0.id })
            default:
                PostOption(categoryId: $0.id, optionsIds: $0.options.filter { $0.isActive }.map { $0.id })
            }
        })
    }
}
