//
//  RouteDetailViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

// TODO: - 위치 고민
enum RouteDetailRoute {
    case back
    case followRoute(routeId: Int)
}

class RouteDetailViewModel: ObservableObject {
    var postId: Int?
    var userId: Int?
    var routeId: Int?
    
    @Published var title = "            "
    @Published var address: String = "          "
    @Published var petProfileImageURL = "           "
    @Published var recordDate: String = "           "
    @Published var walkRecord: String = "           "
    @Published var tagList: [String] = []
    @Published var isExpanded: Bool = false
    @Published var petName = "          "
    @Published var routeImageURL = "            "
    @Published var description = "          "
    @Published var walkImageUrls: [String] = []
    @Published var isPublic = false
    @Published var isMine = false
    @Published var loadingStatus: LoadingStatus = .ready
    @Published var reviews: [ReviewResponse.CategoryTop] = []
    @Published var totalReviewCount = 0
    @Published var isShowEditSheet = false
    @Published var isShowDeleteAlert = false

    // 수정 시 전달할 원본 데이터
    var walkImageIds: [Int] = []
    var rawWalkImages: [PostDetailResponse.WalkImage] = []
    var rawCategoryTexts: [String] = []

    private let postAPIService: PostAPIService
    
    init(postAPIService: PostAPIService, postId: Int? = nil) {
        self.postAPIService = postAPIService
        self.postId = postId
    }
    
    //MARK: - Navigation
    
    var navigationAction: ((RouteDetailRoute)->())?
    
    func setRouteId(routeId: Int) {
        self.routeId = routeId
    }
    
    func navigateToBack() {
        navigationAction?(.back)
        isExpanded = false
    }
    
    @MainActor
    func fetchPost() {
        Task {
            loadingStatus = .loading
            do {
                guard let postId else { return }
                let response = try await postAPIService.fetchPost(postId: postId)
                guard let data = response.data else { return }
                
                address = data.routeDisplay.locationText
                petProfileImageURL = data.authorInfo.petProfileImage
                tagList = data.categoryTagTexts.map { text in
                    switch text {
                    case "적음", "평범", "많음":
                        return "혼잡도 \(text)"
                    case "보통":
                        return "교류 \(text)"
                    default:
                        return text
                    }
                }
                walkRecord = data.routeDisplay.metaTagTexts.joined(separator: " | ")
                petName = data.authorInfo.petName
                routeImageURL = data.routeDisplay.routeImageUrl
                recordDate = data.routeDisplay.dateTimeText
                title = data.title
                description = data.description
                walkImageUrls = data.walkImages.map { $0.imageUrl }
                walkImageIds = data.walkImages.map { $0.imageId }
                rawWalkImages = data.walkImages
                rawCategoryTexts = data.categoryTagTexts
                isPublic = data.isPublic
                isMine = data.isMine
                userId = data.authorInfo.authorId
                routeId = data.routeDisplay.routeId
                loadingStatus = .success
            } catch {
                loadingStatus = .failed(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func fetchReview() {
        Task {
            do {
                guard let userId, let routeId else { return }
                let response = try await postAPIService.fetchReview(userId: userId, routeId: routeId)
                reviews = response.categoryTop3.sorted(by: {$0.rank < $1.rank})
                totalReviewCount = response.totalReviewCount
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func navigateToFollowRouteFollowRoute() {
        navigationAction?(.followRoute(routeId: routeId ?? 0))
    }

    func deletePostTapped() {
        isShowDeleteAlert = true
    }

    func editPostTapped() {
        isShowEditSheet = true
    }

    @MainActor
    func deletePost() {
        Task {
            guard let postId else { return }
            do {
                try await postAPIService.deletePost(postId: postId)
                navigateToBack()
            } catch {
                print("게시글 삭제 실패:", error.localizedDescription)
            }
        }
    }
}
