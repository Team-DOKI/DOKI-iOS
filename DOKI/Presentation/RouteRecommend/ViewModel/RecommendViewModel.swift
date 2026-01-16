//
//  RecommendViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class RecommendViewModel: ObservableObject {
    private let coordinator: Coordinator<RecommendRoute>
    
    @Published var selectedFilterOption: [FilteringOption] = []
    
    init(coordinator: Coordinator<RecommendRoute>) {
        self.coordinator = coordinator
    }
    
    func navigateToDetail(id: Int) {
        coordinator.push(.courseDetail(id: id))
    }
    
    func navigateToFilterSetting() {
        coordinator.push(.filterSetting)
    }
}

struct FilterTagItem: Identifiable {
    let id = UUID()
    let text: String
    let isActive: Bool
}

enum FilterCategory: String, CaseIterable {
    case walkTime
    case congestion
    case dogInteraction
    case safety
    case convenience
    case environment
    
    var title: String {
        switch self {
        case .walkTime: return "산책 소요 시간"
        case .congestion: return "혼잡도"
        case .dogInteraction: return "강아지 교류 빈도"
        case .safety: return "안전"
        case .convenience: return "편의성"
        case .environment: return "환경"
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
                        text = "\(category.title) \(option.text)"
                    }
                    return FilterTagItem(text: text, isActive: true)
                }
            }
        }
    }
}
