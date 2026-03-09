//
//  RegionGeometryResponse.swift
//  DOKI
//
//  Created by 이세민 on 3/9/26.
//

struct RegionGeometryResponse: Codable {
    let regionId: Int
    let regionName: String
    let geometry: Geometry
}

struct Geometry: Codable {
    let type: String
    let coordinates: [[[[Double]]]] // MultiPolygon
}
