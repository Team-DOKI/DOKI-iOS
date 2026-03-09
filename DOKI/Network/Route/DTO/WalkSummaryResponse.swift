//
//  WalkSummaryResponse.swift
//  DOKI
//
//  Created by 이세민 on 3/8/26.
//

struct WalkSummaryResponse: Codable {
    let routeDisplay: RouteDisplay
}

struct RouteDisplay: Codable {
    let routeId: Int
    let locationText: String
    let dateTimeText: String
    let metaTagTexts: [String]
}
