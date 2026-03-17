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
    case toggleLike(postId: Int) // 게시글 좋아요/취소
    
    case fetchWalkSummary(routeId: Int) // 산책 후 산책 정보 조회
    case fetchRouteGeometry(routeId: Int) // 루트 좌표 조회
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
        case .toggleLike(let postId):
            return "posts/\(postId)/likes"
        case .fetchWalkSummary(let routeId):
            return "routes/\(routeId)/summary"
        case .fetchRouteGeometry(let routeId):
                return "routes/\(routeId)/geometry"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .toggleLike:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        return .requestPlain
    }
}
