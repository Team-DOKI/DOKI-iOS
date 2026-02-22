//
//  RegionsResponse.swift
//  DOKI
//
//  Created by 이세민 on 2/22/26.
//

struct RegionsResponse: Codable {
    let districtDtos: [DistrictDTOs]
}

struct DistrictDTOs: Codable {
    let gu: Gu
    let dongs: [Dong]
}

struct Gu: Codable {
    let id: Int
    let name: String
}

struct Dong: Codable {
    let id: Int
    let name: String
}
