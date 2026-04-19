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
    /// 따라걷기 리뷰 헤더 조회
    func fetchReviewHeader(
        postId: Int,
        completion: @escaping (NetworkResult<ReviewHeaderResponseDTO>) -> Void
    )
    /// 리뷰 등록
    func registerReview(
        request: ReviewRegisterRequest,
        completion: @escaping (NetworkResult<EmptyResponseDTO>) -> Void
    )
}

extension ReviewAPIServiceProtocol {
    typealias MyReviewsResponseDTO = BaseDTO<MyReviewsResponse>
    typealias ReviewHeaderResponseDTO = BaseDTO<ReviewHeaderResponse>
    typealias EmptyResponseDTO = BaseDTO<EmptyResponse>
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

    /// 따라걷기 리뷰 헤더 조회
    func fetchReviewHeader(
        postId: Int,
        completion: @escaping (NetworkResult<ReviewHeaderResponseDTO>) -> Void
    ) {
        self.request(
            .fetchReviewHeader(postId: postId),
            provider: provider,
            responseType: ReviewHeaderResponseDTO.self,
            completion: completion
        )
    }

    /// 리뷰 등록
    func registerReview(
        request: ReviewRegisterRequest,
        completion: @escaping (NetworkResult<EmptyResponseDTO>) -> Void
    ) {
        self.request(
            .registerReview(request: request),
            provider: provider,
            responseType: EmptyResponseDTO.self,
            completion: completion
        )
    }
}
