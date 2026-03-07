//
//  PostAPI.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

import Moya

enum PostAPI {
    case fetchPosts(sortOption: SortOption, cursor: String)
}

extension PostAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchPosts:
            return "posts/filter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPosts:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchPosts(sortOption, cursor):
            
            return .requestCompositeParameters(
                bodyParameters: [
                    "selectedOptions" : []
                ],
                bodyEncoding: JSONEncoding.default,
                urlParameters: cursor.isEmpty ? ["sortBy": sortOption.rawValue, "size": 20] :
                    ["sortBy": sortOption.rawValue, "cursor": cursor, "size": 20]
            )
        }
    }
}
