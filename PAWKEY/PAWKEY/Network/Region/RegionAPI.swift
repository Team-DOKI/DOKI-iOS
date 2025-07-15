//
//  RegionAPI.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

import Moya

enum RegionAPI {
    case fetchRegions
}

extension RegionAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchRegions:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchRegions:
            return "pets/traits/regions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchRegions:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchRegions:
            return .requestPlain
        }
    }
}
