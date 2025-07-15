//
//  SharedWalkCourseDTO.swift
//  PAWKEY
//
//  Created by 이세민 on 7/16/25.
//

import Foundation

struct SharedWalkCourseDTO: Codable {
    let routeId: Int
    let geometryDto: GeometryDto
}

struct GeometryDto: Codable {
    let type: String
    let coordinates: [[Double]]
}
