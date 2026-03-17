//
//  PostAPI.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

import Moya
import Foundation

enum PostAPI {
    case fetchPosts(sortOption: SortOption, cursor: String, postRequestDto: PostRequest)
    case uploadPost(request: PostRegisterRequest)
    case fetchPost(postId: Int)
    case fetchReview(userId: Int, routeId: Int)
}

extension PostAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchPosts:
            return "posts/filter"
        case .uploadPost:
            return "posts"
        case .fetchPost(let postId):
            return "posts/\(postId)"
        case .fetchReview(let userId, let routeId):
            return "posts/\(routeId)/reviews/top"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPosts, .uploadPost:
            return .post
        case .fetchPost, .fetchReview:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchPosts(sortOption, cursor, postRequestDto):
            // cursor가 없다면 cursor를 제거하고 요청
            let urlParameters: [String: Any] = cursor.isEmpty
            ? ["sortBy": sortOption.rawValue, "size": 20]
            : ["sortBy": sortOption.rawValue, "cursor": cursor, "size": 20]
            
            let bodyData: Data
            
            do {
                bodyData = try JSONEncoder().encode(postRequestDto)
            } catch {
                fatalError("Encoding failed: \(error)")
            }
            
            return .requestCompositeData(
                bodyData: bodyData,
                urlParameters: urlParameters
            )
        case let .uploadPost(request):
            return .requestJSONEncodable(request)
        case .fetchPost:
            return .requestPlain
        case .fetchReview(let userId, let routeId):
            return .requestParameters(parameters: ["userId": userId, "routeId": routeId], encoding: URLEncoding.queryString)
        }
    }
}
