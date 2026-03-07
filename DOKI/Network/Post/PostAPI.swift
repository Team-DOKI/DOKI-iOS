//
//  PostAPI.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

import Moya

enum PostAPI {
    case fetchPosts(sortOption: SortOption)
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
        case let .fetchPosts(sortOption):
            return .requestCompositeParameters(
                bodyParameters: [
                    "selectedOptions" : []
                ],
                bodyEncoding: JSONEncoding.default,
                urlParameters: [
                    "sortBy": sortOption.rawValue,
//                    "cursor": "0",
                    "size": 10
                ]
            )
        }
    }
}
