//
//  WalkReviewViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkReviewViewModel: ObservableObject {
    private let routeAPIService: RouteAPIServiceProtocol = RouteAPIService()
    
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

extension WalkReviewViewModel {
    func fetchWalkSummary() {
        
        guard let routeId = WalkSessionManager.shared.nRouteId else { return }
        
        routeAPIService.fetchWalkSummary(routeId: routeId) { [weak self] result in
            switch result {
            case .success(let response):
                guard
                    let data = response?.data?.routeDisplay
                else { return }
                
                DispatchQueue.main.async {
                    self?.address = data.locationText
                    self?.recordDate = data.dateTimeText
                    self?.walkRecord = data.metaTagTexts.joined(separator: " | ")
                }
                
            default:
                print("산책 요약 정보 조회에 실패했습니다.")
            }
        }
    }
}
