//
//  ActivityAreaMapDTO.swift
//  PAWKEY
//
//  Created by 이세민 on 7/14/25.
//

import Foundation

struct RegionDTO: Codable {
    let preRegionName: String
    let regionName: String
    let geometryDto: GeometryDTO
}

struct GeometryDTO: Codable {
    let type: String
    let coordinates: [[[[Double]]]]
}
