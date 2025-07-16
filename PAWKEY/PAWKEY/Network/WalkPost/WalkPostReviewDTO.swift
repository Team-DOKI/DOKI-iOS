//
//  WalkPostReviewDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/17/25.
//

import Foundation

struct WalkPostReviewDTO: Codable {
    let postId: Int
    let totalReviewCount: Int
    let categoryTop3: [CategoryTopDTO]
}

struct CategoryTopDTO: Codable {
    let categoryId: Int
    let categoryName: String
    let categoryOptionId: Int
    let optionText: String
    let rank: Int
    let percentage: Int
}


