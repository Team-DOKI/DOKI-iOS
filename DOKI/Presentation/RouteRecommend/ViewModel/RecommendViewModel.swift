//
//  RecommendViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case latest = "latest"
    case popular = "popular"
    
    var displayText: String {
        switch self {
        case .latest:
            "최신순"
        case .popular:
            "인기순"
        }
    }
}

enum LoadingStatus: Equatable {
    case failed(String)
    case loading
    case success
    case ready
}

class RecommendViewModel: ObservableObject {
    private let coordinator: Coordinator<RecommendRoute>
    
    @Published var selectedFilterOption: [FilteringOption] = []
    @Published var posts: [PostItem] = []
    @Published var selectedSort: SortOption = .latest
    @Published var loadingStatus: LoadingStatus = .ready
    
    
    private var hasNext: Bool = true
    
    private let postAPIservice: PostAPIServiceProtocol
    private let routeAPIService: RouteAPIServiceProtocol
    
    @Published var filterOptions: [FilterList] = []
    var nextCursorId: String = ""
    
    var navigationAction: ((RecommendRoute)->())?
    
    init(
        coordinator: Coordinator<RecommendRoute>,
        postAPIservice: PostAPIServiceProtocol,
        routeAPIService: RouteAPIServiceProtocol
    ) {
        self.postAPIservice = postAPIservice
        self.routeAPIService = routeAPIService
        self.coordinator = coordinator
        
    }
    
    func navigateToRouteDetail(postId: Int) {
        coordinator.push(.routeDetail(postId: postId))
    }

    func toggleLike(postId: Int) {
        routeAPIService.toggleLike(postId: postId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let status = response?.data?.status else { return }
                    if let index = self?.posts.firstIndex(where: { $0.postId == postId }) {
                        self?.posts[index].isLiked = status == "LIKE_SUCCESS"
                    }
                default:
                    print("좋아요 실패")
                }
            }
        }
    }

    func navigateToFilterSetting(focusedType: FilterType? = nil) {
        pendingFocusedFilterType = focusedType
        coordinator.push(.filterSetting)
        navigationAction?(.filterSetting)
    }

    var pendingFocusedFilterType: FilterType? = nil
    
    func selecteSortOption(_ sort: SortOption) {
        self.selectedSort = sort
        loadPosts()
    }
}

// MARK: - API (게시물 조회)

extension RecommendViewModel {
    
    /// 기존 데이터를 제거하고 새로운 게시물을 요청
    func loadPosts() {
        loadingStatus = .loading
        nextCursorId = ""
        
        Task {
            do {
                let response = try await postAPIservice.fetchPosts(
                    sortOption: selectedSort,
                    cursor: nextCursorId,
                    options: filterOptions
                )
                await MainActor.run {
                    posts = response.posts
                    loadingStatus = .success
                }
                nextCursorId = response.nextCursor
                hasNext = response.hasNext
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    loadingStatus = .failed(error.localizedDescription)
                    posts = []
                }
            }
        }
    }
    
    /// 기존 데이터를 유지하고 nextCursorId를 기준으로 새로운 게시물을 요청
    func fetchPosts() {
        loadingStatus = .loading
        
        Task {
            do {
                let response = try await postAPIservice.fetchPosts(
                    sortOption: selectedSort,
                    cursor: nextCursorId,
                    options: filterOptions
                )
                await MainActor.run {
                    posts = posts + response.posts
                    loadingStatus = .success
                }
                nextCursorId = response.nextCursor
                hasNext = response.hasNext
            } catch {
                print(error.localizedDescription)
                await MainActor.run {
                    loadingStatus = .failed(error.localizedDescription)
                    posts = []
                }
            }
        }
    }
    
}
