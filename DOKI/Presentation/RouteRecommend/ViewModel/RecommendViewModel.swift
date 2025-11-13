//
//  RecommendViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

class RecommendViewModel: ObservableObject {
    private let coordinator: Coordinator<RecommendRoute>
    
    @Published var selectedFilterOption: [FilteringOption] = []
    @Published var dummyFilterOption: [FilteringOption] = [
        FilteringOption(text: "산책소요시간", isActive: false),
        FilteringOption(text: "혼잡도", isActive: false),
        FilteringOption(text: "강아지 교류 빈도", isActive: false),
        FilteringOption(text: "안전", isActive: false),
        FilteringOption(text: "편의성", isActive: false),
        FilteringOption(text: "환경", isActive: false),
    ]
    
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
