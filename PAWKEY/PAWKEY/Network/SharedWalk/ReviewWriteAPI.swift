//
//  ReviewWriteAPI.swift
//  PAWKEY
//
//  Created by 이세민 on 7/16/25.
//

import Foundation
import Moya

enum ReviewWriteAPI {
    case fetchCourseCategories
    case postReview(body: ReviewWriteDTO)
}

extension ReviewWriteAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchCourseCategories, .postReview:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchCourseCategories:
            return "posts/categories"
        case .postReview:
            return "/reviews"
        }
    }
    var method: Moya.Method {
        switch self {
        case .postReview:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchCourseCategories:
            return .requestPlain
        case .postReview(let body):
            return .requestJSONEncodable(body)
        }
    }
}
