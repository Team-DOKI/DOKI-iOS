//
//  RecommendViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

class RecommendViewModel: ObservableObject {
    private let coordinator: Coordinator<RecommendRoute>
    
    init(coordinator: Coordinator<RecommendRoute>) {
        self.coordinator = coordinator
    }
    
    func navigateToDetail(id: Int) {
        coordinator.push(.courseDetail(id: id))
    }
}
