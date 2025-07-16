//
//  ReviewWriteDTO.swift
//  PAWKEY
//
//  Created by 이세민 on 7/16/25.
//

import Foundation

struct ReviewWriteDTO: Codable {
    var routeId: Int
    var selectedReviewCategory: [ReviewCategory]
}

struct ReviewCategory: Codable {
    var reviewCategoryId: Int
    var selectedReviewOptionIds: [Int]
}
