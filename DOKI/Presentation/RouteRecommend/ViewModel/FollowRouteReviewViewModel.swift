//
//  FollowRouteReviewViewModel.swift
//  DOKI
//
//  Created by 이세민 on 3/13/26.
//

import SwiftUI

final class FollowRouteReviewViewModel: ObservableObject {

    // MARK: - Route Info (API)
    @Published var routeTitle: String = ""
    @Published var petProfileImageURL: String = ""
    @Published var petName: String = ""

    // MARK: - Walk Summary (client-side)
    @Published var address: String = ""
    @Published var recordDate: String = ""
    @Published var walkRecord: String = ""

    // MARK: - Filter Categories
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedExchange: FilteringOption?
    @Published var congestion: [FilteringOption] = []
    @Published var exchange: [FilteringOption] = []
    @Published var safety: [FilteringOption] = []
    @Published var convenience: [FilteringOption] = []
    @Published var environment: [FilteringOption] = []

    @Published var loadingStatus: LoadingStatus = .ready
    @Published var isShowCompleteAlert: Bool = false

    private var postId: Int = 0
    private var routeId: Int = 0
    private var selectedFilterOptions: [FilterList] = []
    private let filterAPIService: FilterAPIService = FilterAPIService()
    private let reviewAPIService: ReviewAPIService = ReviewAPIService()

    var navigationAction: ((FollowRouteReviewRoute) -> Void)?

    // MARK: - Validation

    var isFormValid: Bool {
        guard selectedCongestion != nil,
              selectedExchange != nil else { return false }
        let hasSafety = safety.contains { $0.isActive }
        let hasConvenience = convenience.contains { $0.isActive }
        let hasEnvironment = environment.contains { $0.isActive }
        return hasSafety && hasConvenience && hasEnvironment
    }

    // MARK: - Setup (coordinator에서 호출)

    func setup(postId: Int, routeId: Int, address: String) {
        self.postId = postId
        self.routeId = routeId
        self.address = address
    }

    func setWalkData(distanceString: String, elapsedTimeString: String, stepString: String, startDate: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy.MM.dd | a hh:mm"
        recordDate = formatter.string(from: startDate)
        walkRecord = "\(distanceString)km | \(elapsedTimeString) | \(stepString)걸음"
    }

    // MARK: - API

    @MainActor
    func fetchReviewHeader() async {
        guard postId > 0 else { return }
        loadingStatus = .loading
        reviewAPIService.fetchReviewHeader(postId: postId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let data = response?.data else { return }
                    self.routeTitle = data.postTitle
                    self.petProfileImageURL = data.reviewerProfile.profileImageUrl
                    self.petName = data.reviewerProfile.profileName
                    self.loadingStatus = .success
                default:
                    self.loadingStatus = .failed("헤더 조회 실패")
                }
            }
        }
    }

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
        guard let request = buildReviewRequest() else { return }
        reviewAPIService.registerReview(request: request) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isShowCompleteAlert = true
                default:
                    print("리뷰 등록 실패")
                }
            }
        }
    }

    func dismissAfterAlert() {
        navigationAction?(.backToRoot)
    }

    // MARK: - Private

    private func buildReviewRequest() -> ReviewRegisterRequest? {
        guard let selectedCongestion, let selectedExchange else { return nil }

        var reviewSets: [ReviewRegisterRequest.ReviewSet] = []

        if let cat = selectedFilterOptions.first(where: { $0.filterType == .congestion }) {
            reviewSets.append(.init(reviewCategoryId: cat.id, selectedReviewOptionIds: [selectedCongestion.id]))
        }
        if let cat = selectedFilterOptions.first(where: { $0.filterType == .exchange }) {
            reviewSets.append(.init(reviewCategoryId: cat.id, selectedReviewOptionIds: [selectedExchange.id]))
        }
        if let cat = selectedFilterOptions.first(where: { $0.filterType == .safety }) {
            let ids = safety.filter { $0.isActive }.map { $0.id }
            if !ids.isEmpty { reviewSets.append(.init(reviewCategoryId: cat.id, selectedReviewOptionIds: ids)) }
        }
        if let cat = selectedFilterOptions.first(where: { $0.filterType == .convenience }) {
            let ids = convenience.filter { $0.isActive }.map { $0.id }
            if !ids.isEmpty { reviewSets.append(.init(reviewCategoryId: cat.id, selectedReviewOptionIds: ids)) }
        }
        if let cat = selectedFilterOptions.first(where: { $0.filterType == .environment }) {
            let ids = environment.filter { $0.isActive }.map { $0.id }
            if !ids.isEmpty { reviewSets.append(.init(reviewCategoryId: cat.id, selectedReviewOptionIds: ids)) }
        }

        return ReviewRegisterRequest(routeId: routeId, selectedReviewSetList: reviewSets)
    }
}
