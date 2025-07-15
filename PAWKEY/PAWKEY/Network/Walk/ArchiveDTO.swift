//
//  ArchiveDTO.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import Foundation

// Response
struct ArchiveInfoDTO: Codable {
    let routeDto: Route
    let petName: String
}

struct Route: Codable {
    let id: Int
    let locationDescription: String
    let dateDescription: String
    let descriptionTags: [String]
}

