//
//  ReviewRegisterRequest.swift
//  DOKI
//
//  Created by 이세민 on 4/16/26.
//

import Foundation

struct ReviewRegisterRequest: Encodable {
    let routeId: Int
    let selectedReviewSetList: [ReviewSet]

    struct ReviewSet: Encodable {
        let reviewCategoryId: Int
        let selectedReviewOptionIds: [Int]
    }
}
