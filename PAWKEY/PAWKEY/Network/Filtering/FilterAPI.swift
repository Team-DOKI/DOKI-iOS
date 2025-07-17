//
//  FilterAPI.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

import Moya

enum FilterAPI {
    case fetchFilterOptions
}

extension FilterAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchFilterOptions:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchFilterOptions:
            return "posts/filter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFilterOptions:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchFilterOptions:
            return .requestPlain
        }
    }
}
