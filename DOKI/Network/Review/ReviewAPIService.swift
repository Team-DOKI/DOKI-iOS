//
//  ReviewAPIServiceProtocol.swift
//  DOKI
//
//  Created by 이세민 on 3/2/26.
//

import Foundation
import Moya

protocol ReviewAPIServiceProtocol {
    /// 내가 작성한 리뷰 조회
    func fetchMyReviews(
        completion: @escaping (NetworkResult<MyReviewsResponseDTO>) -> Void
    )
}

extension ReviewAPIServiceProtocol {
    typealias MyReviewsResponseDTO = BaseDTO<MyReviewsResponse>
}

final class ReviewAPIService: BaseAPIService, ReviewAPIServiceProtocol {
    
    private let provider = MoyaProvider<ReviewAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 내가 작성한 리뷰 조회
    func fetchMyReviews(
        completion: @escaping (NetworkResult<MyReviewsResponseDTO>) -> Void
    ) {
        self.request(
            .fetchMyReviews,
            provider: provider,
            responseType: MyReviewsResponseDTO.self,
            completion: completion
        )
    }
}
