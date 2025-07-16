//
//  MyCourseAPI.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//


import Foundation

import Moya

enum MyCourseAPI {
    case getMyCourse
}

extension MyCourseAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getMyCourse:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .getMyCourse:
            return "users/me/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyCourse:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMyCourse:
            return .requestPlain
        }
    }
}
