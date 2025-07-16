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
    case fetchPostDetail(postId: Int)
}

extension WalkPostAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchPosts:
            return .userHeader(userId: 2)
        default:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchPosts:
            return "posts/filter"
        case let .fetchPostDetail(postId):
            return "posts/\(postId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPosts:
            return .post
        case .fetchPostDetail(_):
            return .get
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
        case .fetchPostDetail(_):
            return .requestPlain
        }
    }
}

