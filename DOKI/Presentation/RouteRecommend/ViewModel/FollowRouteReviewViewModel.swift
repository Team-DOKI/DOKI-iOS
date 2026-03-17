//
//  FollowRouteReviewViewModel.swift
//  DOKI
//
//  Created by 이세민 on 3/13/26.
//

import Foundation

final class FollowRouteReviewViewModel: ObservableObject {
    @Published var reviewText: String = ""
    
    var navigationAction: ((FollowRouteReviewRoute) -> Void)?
    
    func completeReview() {
        navigationAction?(.backToRoot)
    }
}
