//
//  RegionAPI.swift
//  DOKI
//
//  Created by a on 12/9/25.
//

import Foundation

import Moya

enum RegionAPI {
    case fetchRegions
}

extension RegionAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchRegions:
            return "regions"
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
