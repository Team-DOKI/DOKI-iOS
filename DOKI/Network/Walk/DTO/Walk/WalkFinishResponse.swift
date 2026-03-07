//
//  WalkFinishResponse.swift
//  DOKI
//
//  Created by 이세민 on 3/7/26.
//

import Foundation

struct WalkFinishResponse: Codable {
    let routeId: Int
    let petProfile: Pet
    let walkInfo: WalkInfo
}

struct Pet: Codable {
    let name: String
    let imageUrl: String
}

struct WalkInfo: Codable {
    let startedAt: String
}
