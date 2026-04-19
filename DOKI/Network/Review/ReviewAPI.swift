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
    case fetchReviewHeader(postId: Int) // 따라걷기 리뷰 헤더 조회
    case registerReview(request: ReviewRegisterRequest) // 리뷰 등록
}

extension ReviewAPI: BaseTargetType {
    var headerType: HeaderType {
        .defaultHeader
    }

    var path: String {
        switch self {
        case .fetchMyReviews:
            return "users/me/reviews"
        case .fetchReviewHeader(let postId):
            return "reviews/\(postId)/review-header"
        case .registerReview:
            return "reviews"
        }
    }

    var method: Moya.Method {
        switch self {
        case .registerReview:
            return .post
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .registerReview(let request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }
}
