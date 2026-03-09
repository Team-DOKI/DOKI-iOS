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
        }
    }
}
