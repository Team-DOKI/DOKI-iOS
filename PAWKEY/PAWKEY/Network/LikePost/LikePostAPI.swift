//
//  LikePostAPI.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/17/25.
//

import Foundation

import Moya

enum LikePostAPI {
    case postLike(postId: Int)
    case deleteLike(postId: Int)
}

extension LikePostAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .postLike(let postId), .deleteLike(let postId):
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .postLike(let postId), .deleteLike(let postId):
            return "likes/\(postId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLike(let postId):
            return .post
        case .deleteLike(let postId):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postLike(let postId):
            return .requestPlain
        case .deleteLike(let postId):
            return .requestPlain
        }
    }
}
