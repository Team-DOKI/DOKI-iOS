//
//  RegionAPI.swift
//  DOKI
//
//  Created by a on 12/9/25.
//

import Foundation

import Moya

enum RegionAPI {
    case fetchRegions //  지역구 조회
    case fetchRegionGeometry(regionId: Int) // 지역 폴리곤 좌표 조회
    case fetchMyRegion // 내 현재 지역 조회
}

extension RegionAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchRegions:
            return "regions"
        case .fetchRegionGeometry(let regionId):
            return "regions/\(regionId)/geometry"
        case .fetchMyRegion:
            return "regions/current"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchRegions, .fetchRegionGeometry, .fetchMyRegion:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchRegions, .fetchRegionGeometry, .fetchMyRegion:
            return .requestPlain
        }
    }
}
