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

extension Array where Element == DistrictUnitDTO {
    func toEntity() -> [RegionUnit] {
        map { RegionUnit(gu: $0.gu.toEntity(), dong: $0.dongs.toEntity())}
    }
}

extension AreaDTO {
    func toEntity() -> Area {
        Area(id: id, name: name)
    }
}

extension Array where Element == AreaDTO {
    func toEntity() -> [Area] {
        map { Area(id: $0.id, name: $0.name )}
    }
}
