//
//  WalkReviewViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkReviewViewModel: ObservableObject {
    var navigationAction: ((WalkReviewRoute)->())?
    
    @Published var isShowReviewCompleted: Bool = false
    @Published var reviewTitle: String = ""
    @Published var reviewContent: String = ""
    @Published var address: String = "상세 주소"
    @Published var recordDate: String = "YY.MM.DD | 오후 00:00"
    @Published var walkRecord: String = "거리 | 시간 | 걸음수"
    @Published var reviewImages: [UIImage] = []
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedDogInteraction: FilteringOption?
    @Published var safetyOption: [FilteringOption] = []
    
    @Published var convenienceOption: [FilteringOption] = []
    
    @Published var environmentOption: [FilteringOption] = []
    
    @Published var congestionOption: [FilteringOption] = []
    
    @Published var dogInteractionOption: [FilteringOption] = []
    
    func navigateBackToRoot() {
        navigationAction?(.backToRoot)
    }
    
    func navigateToDetail() {
        navigationAction?(.routeDetail)
    }
    
    func showReviewComplete() {
        isShowReviewCompleted = true
    }
}
