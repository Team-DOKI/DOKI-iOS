//
//  WalkFinishRequest.swift
//  DOKI
//
//  Created by 이세민 on 3/7/26.
//

import Foundation

struct WalkFinishRequest: Codable {
    let distance: Double
    let duration: Int
    let stepCount: Int
    let endedAt: String
}
