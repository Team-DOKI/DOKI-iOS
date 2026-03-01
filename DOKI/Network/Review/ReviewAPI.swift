//
//  ReviewAPI.swift
//  DOKI
//
//  Created by 이세민 on 3/2/26.
//

import Foundation
import Moya

enum ReviewAPI {
    case fetchMyReviews // 내가 작성한 리뷰 조회
}

extension ReviewAPI: BaseTargetType {
    var headerType: HeaderType {
        .defaultHeader
    }

    var path: String {
        switch self {
        case .fetchMyReviews:
            return "users/me/reviews"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }
}
