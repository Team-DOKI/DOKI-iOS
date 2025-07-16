//
//  MyRegionAPI.swift
//  PAWKEY
//
//  Created by 이세민 on 7/17/25.
//

import Foundation

import Moya

enum MyRegionAPI {
    case fetchMyRegion
}

extension MyRegionAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .fetchMyRegion:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyRegion:
            return "regions/current"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyRegion:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMyRegion:
            return .requestPlain
        }
    }
}
