//
//  RouteInfoResponse.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import Foundation

struct RouteInfoResponse: Codable {
    let posts: [Posts]
}

struct Posts: Codable {
    let postId: Int
    let regionName: String
    let title: String
    let date: String
    let durationMinutes: Int
    let isLiked: Bool
    let imageUrl: String
}
