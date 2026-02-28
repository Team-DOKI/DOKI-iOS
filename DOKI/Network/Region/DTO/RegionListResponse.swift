//
//  RegionsResponse.swift
//  DOKI
//
//  Created by 이세민 on 2/22/26.
//

struct RegionListResponse: Codable {
    let districtDtos: [DistrictDTOs]
}

struct DistrictDTOs: Codable {
    let gu: Gu
    let dongs: [Dongs]
}

struct Gu: Codable {
    let id: Int
    let name: String
}

struct Dongs: Codable {
    let id: Int
    let name: String
}
