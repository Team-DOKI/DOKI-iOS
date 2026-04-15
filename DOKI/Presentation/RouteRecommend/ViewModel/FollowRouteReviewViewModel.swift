//
//  FollowRouteReviewViewModel.swift
//  DOKI
//
//  Created by 이세민 on 3/13/26.
//

import SwiftUI

final class FollowRouteReviewViewModel: ObservableObject {

    // MARK: - Route Info (from post)
    @Published var routeTitle: String = "          "
    @Published var petProfileImageURL: String = ""
    @Published var petName: String = "          "

    // MARK: - Walk Summary
    @Published var address: String = "상세 주소"
    @Published var recordDate: String = "YY.MM.DD | 오후 00:00"
    @Published var walkRecord: String = "거리 | 시간 | 걸음수"

    // MARK: - Filter Categories
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedExchange: FilteringOption?
    @Published var congestion: [FilteringOption] = []
    @Published var exchange: [FilteringOption] = []
    @Published var safety: [FilteringOption] = []
    @Published var convenience: [FilteringOption] = []
    @Published var environment: [FilteringOption] = []

    @Published var loadingStatus: LoadingStatus = .ready

    private var selectedFilterOptions: [FilterList] = []
    private let filterAPIService: FilterAPIService = FilterAPIService()

    var navigationAction: ((FollowRouteReviewRoute) -> Void)?

    // MARK: - Filter Categories

    @MainActor
    func fetchFilterCategories() async {
        guard selectedFilterOptions.isEmpty else { return }
        do {
            selectedFilterOptions = try await filterAPIService.fetchFilterCategories()
            selectedFilterOptions.forEach {
                switch $0.filterType {
                case .congestion:
                    congestion = $0.options
                case .exchange:
                    exchange = $0.options
                case .safety:
                    safety = $0.options
                case .convenience:
                    convenience = $0.options
                case .environment:
                    environment = $0.options
                default:
                    break
                }
            }
        } catch {
            print("필터 카테고리 조회 실패:", error.localizedDescription)
        }
    }

    // MARK: - Navigation

    func completeReview() {
        // TODO: - API 연동
        navigationAction?(.backToRoot)
    }
}
