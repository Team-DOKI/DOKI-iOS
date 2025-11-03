//
//  RecommendViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

class RecommendViewModel: ObservableObject {
    private let coordinator: Coordinator<RecommendRoute>
    
    @Published var filterTags: [FilterTag] = [
        FilterTag(text: "산책 소요 시간", isActive: true),
        FilterTag(text: "혼잡도", isActive: false),
        FilterTag(text: "강아지 교류 빈도", isActive: false),
        FilterTag(text: "산책 소요 시간", isActive: true),
        FilterTag(text: "혼잡도", isActive: false),
        FilterTag(text: "강아지 교류 빈도", isActive: false),
        FilterTag(text: "산책 소요 시간", isActive: true),
        FilterTag(text: "혼잡도", isActive: false),
        FilterTag(text: "강아지 교류 빈도", isActive: false)
    ]
    
    
    init(coordinator: Coordinator<RecommendRoute>) {
        self.coordinator = coordinator
    }
    
    func navigateToDetail(id: Int) {
        coordinator.push(.courseDetail(id: id))
    }
}
