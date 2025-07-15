//
//  RegionDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

struct DistrictDTO: Codable {
    let districtDtos: [DistrictUnitDTO]
}

struct DistrictUnitDTO: Codable {
    let gu: AreaDTO
    let dongs: [AreaDTO]
}

struct AreaDTO: Codable {
    let id: Int
    let name: String
}
