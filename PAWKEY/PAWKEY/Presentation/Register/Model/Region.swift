//
//  Region.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

struct RegionData {
    let regions: [RegionUnit]
}

struct RegionUnit: Hashable {
    let gu: Area
    let dong: [Area]
}

struct Area: Hashable {
    let id: Int
    let name: String
}
