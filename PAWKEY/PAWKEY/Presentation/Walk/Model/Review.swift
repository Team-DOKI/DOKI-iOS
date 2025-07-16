//
//  Review.swift
//  PAWKEY
//
//  Created by 권석기 on 7/17/25.
//

struct WalkPostSummary:Hashable {
    let postId: Int
    let totalReviewCount: Int
    let categoryTop3: [CategoryTop]
}

struct CategoryTop: Hashable {
    let categoryId: Int
    let categoryName: String
    let categoryOptionId: Int
    let optionText: String
    let rank: Int
    let percentage: Int
    
    var ratio: Double {
        Double(percentage) / 100.0
    }
}
