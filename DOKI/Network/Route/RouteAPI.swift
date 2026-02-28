//
//  RouteAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import Foundation
import Moya

enum RouteAPI {
    case fetchMyPosts // 내가 작성한 게시글 조회
    case fetchMyLikedPosts // 내가 좋아요한 게시글 조회
}

extension RouteAPI: BaseTargetType {
    
    var headerType: HeaderType {
        .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchMyPosts:
            return "users/me/posts"
        case .fetchMyLikedPosts:
            return "users/me/likes"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
}
