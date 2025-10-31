//
//  DistrictDTO.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import Foundation

struct RegionResponse: Codable {
    let code: String
    let message: String
    let data: RegionData
}

struct RegionData: Codable {
    let districtDtos: [DistrictDTO]
}

struct DistrictDTO: Codable {
    let gu: Gu
    let dongs: [Dong]
}

struct Gu: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Dong: Codable, Identifiable {
    let id: Int
    let name: String
}
