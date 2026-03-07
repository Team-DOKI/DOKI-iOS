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
    
    var nextCursorId: String = ""
    private var hasNext: Bool = true
    
    private let postAPIservice: PostAPIServiceProtocol
    
    init(coordinator: Coordinator<RecommendRoute>, postAPIservice: PostAPIServiceProtocol) {
        self.postAPIservice = postAPIservice
        self.coordinator = coordinator
    }
    
    func navigateToDetail(id: Int) {
        coordinator.push(.courseDetail(id: id))
    }
    
    func navigateToFilterSetting() {
        coordinator.push(.filterSetting)
    }
    
    func selecteSortOption(_ sort: SortOption) {
        self.selectedSort = sort
        fetchPosts()
    }
}

// MARK: - API (게시물 조회)

extension RecommendViewModel {
    
    func fetchPosts() {
        loadingStatus = .loading
        
        Task {
            do {
                let response = try await postAPIservice.fetchPosts(sortOption: selectedSort, cursor: nextCursorId)
                await MainActor.run {
                    posts = posts + response.posts
                    loadingStatus = .success
                }
                nextCursorId = response.nextCursor
                hasNext = response.hasNext
            } catch {
                print(error.localizedDescription)
                await MainActor.run { loadingStatus = .failed(error.localizedDescription) }
            }
        }
    }
}

extension RecommendViewModel {
    var filterTags: [FilterTagItem] {
        FilterCategory.allCases.flatMap { category in
            let selected = selectedFilterOption.filter { $0.category == category.rawValue }
            
            if selected.isEmpty {
                return [FilterTagItem(text: category.title, isActive: false)]
            } else {
                return selected.map { option in
                    var text = option.text
                    if category == .congestion {
                        text = "\(category.title) \(option.text)" // formattedCategoryTag() 만들어놨음!
                    }
                    return FilterTagItem(text: text, isActive: true)
                }
            }
        }
    }
}
