//
//  RecommendViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case latest = "최신순"
    case popular = "인기순"
}

class RecommendViewModel: ObservableObject {
    private let coordinator: Coordinator<RecommendRoute>
    
    @Published var selectedFilterOption: [FilteringOption] = []
    @Published var posts: [PostItem] = []
    @Published var selectedSort: SortOption = .latest
    
    private var nextCursorId: String = ""
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
}

// MARK: - API (게시물 조회)

extension RecommendViewModel {
    @MainActor
    func fetchPosts() async {
        do {
            let response = try await postAPIservice.fetchPosts()
            posts = response.posts
            nextCursorId = response.nextCursor
            hasNext = response.hasNext
        } catch {
            print(error.localizedDescription)
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
