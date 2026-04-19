//
//  MyReviewsViewModel.swift
//  DOKI
//
//  Created by 이세민 on 3/2/26.
//

import SwiftUI

final class MyReviewsViewModel: ObservableObject {
    @Published var reviews: [ReviewData] = []

    var navigationAction: ((Int) -> Void)?

    private let reviewAPIService: ReviewAPIServiceProtocol

    init(reviewAPIService: ReviewAPIServiceProtocol = ReviewAPIService()) {
        self.reviewAPIService = reviewAPIService
    }
    
    func fetchMyReviews() {
        reviewAPIService.fetchMyReviews { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.reviews = response?.data?.posts.map {
                        ReviewData(
                            id: $0.postId,
                            title: $0.title,
                            address: $0.regionName,
                            date: $0.date.formattedToYYMMDD(),
                            tags: $0.categoryOptionSummary
                        )
                    } ?? []
                default:
                    print("내가 작성한 리뷰 조회에 실패했습니다.")
                }
            }
        }
    }
}
