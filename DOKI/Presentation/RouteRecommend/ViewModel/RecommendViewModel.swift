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
    
    @Published var routeCoordinates: [[Double]] = []
    
    private var hasNext: Bool = true
    
    private let postAPIservice: PostAPIServiceProtocol
    private let routeAPIService: RouteAPIServiceProtocol
    
    var filterOptions: [FilterList] = []
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
        
        fetchRouteGeometry(routeId: 102)
    }
    
    func navigateToDetail(id: Int) {
        coordinator.push(.courseDetail(id: id))
    }
    
    func navigateToFilterSetting() {
        coordinator.push(.filterSetting)
        navigationAction?(.filterSetting)
    }
    
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
    
    func fetchRouteGeometry(routeId: Int) {
        routeAPIService.fetchRouteGeometry(routeId: routeId) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.routeCoordinates = response?.data?.geometry.coordinates ?? []
                }
                
            default:
                print("geometry fetch 실패")
            }
        }
    }
}
