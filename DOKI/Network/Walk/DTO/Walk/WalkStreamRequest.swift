//
//  WalkStreamRequest.swift
//  DOKI
//
//  Created by 이세민 on 3/7/26.
//

import Foundation

struct WalkStreamRequest: Codable {
    let routeId: String
    let lat: Double
    let lng: Double
    let timestamp: Int
}
