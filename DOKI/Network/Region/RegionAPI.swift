//
//  RegionAPI.swift
//  DOKI
//
//  Created by a on 12/9/25.
//

import Foundation

import Moya

enum RegionAPI {
    case getRegions
}

extension RegionAPI: BaseTargetType {
    var validationType: ValidationType {
        .successCodes
    }
    
    var headerType: HeaderType {
        switch self {
        case .getRegions:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .getRegions:
            return "regions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRegions:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getRegions:
            return .requestPlain
        }
    }
}
