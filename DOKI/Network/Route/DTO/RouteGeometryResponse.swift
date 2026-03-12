//
//  RouteGeometryResponse.swift
//  DOKI
//
//  Created by 이세민 on 3/12/26.
//


struct RouteGeometryResponse: Codable {
    let routeId: Int
    let geometry: GeometryDTO
}

struct GeometryDTO: Codable {
    let type: String
    let coordinates: [[Double]]
}
