//
//  SharedWalkCourseAPI.swift
//  PAWKEY
//
//  Created by 이세민 on 7/16/25.
//

import Foundation
import Moya

enum SharedWalkCourseAPI {
    case fetchSharedWalkCourse(routeId: Int)
}

extension SharedWalkCourseAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchSharedWalkCourse:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchSharedWalkCourse(let routeId):
            return "routes/\(routeId)/track"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchSharedWalkCourse:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchSharedWalkCourse:
            return .requestPlain
        }
    }
}
