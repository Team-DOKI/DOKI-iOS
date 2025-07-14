//
//  WalkCoordinateDTO.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import Foundation

// Request
struct WalkCoordinateDTO: Codable {
    let longitude: Double
    let latitude: Double
}

struct WalkCourseRequestDTO: Codable {
    let coordinates: [WalkCoordinateDTO]
    let distance: Int
    let duration: Int
    let startedAt: String
    let endedAt: String
    let stepCount: Int
}

// Response
struct WalkCourseResponseDataDTO: Codable {
    let routeId: Int
}
