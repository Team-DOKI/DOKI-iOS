//
//  FilterAPI.swift
//  DOKI
//
//  Created by 권석기 on 3/4/26.
//

import Moya

enum FilterAPI {
    case fetchFilterCategories
}

extension FilterAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchFilterCategories:
            return "posts/categories/filter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFilterCategories:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchFilterCategories:
            return .requestPlain
        }
    }
}

