//
//  ArchiveAPI.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import Moya

enum ArchiveAPI {
    case fetchCourseInfo(routeId: Int)
}

extension ArchiveAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchCourseInfo:
            return .userHeader(userId: 2)
        }
    }

    var path: String {
        switch self {
        case .fetchCourseInfo(let routeId):
            return "routes/\(routeId)/info"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }
}
