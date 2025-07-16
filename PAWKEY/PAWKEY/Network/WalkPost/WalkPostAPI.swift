//
//  WalkPostAPI.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

import Moya

enum WalkPostAPI {
    case fetchPosts
}

extension WalkPostAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchPosts:
            return .userHeader(userId: 2)
        }
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
        case .fetchPosts:
            let dummy = FilterRequest(
                durationStart: nil,
                durationEnd: nil,
                selectedOptions: [
                    .init(
                        categoryId: nil,
                        optionsIds: nil
                    )
                ]
            )
            return .requestJSONEncodable(dummy)
        }
    }
}

