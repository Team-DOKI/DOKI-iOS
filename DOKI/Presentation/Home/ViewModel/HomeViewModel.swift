//
//  HomeViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    private let coordinator: Coordinator<HomeRoute>
    
    init(coordinator: Coordinator<HomeRoute>) {
        self.coordinator = coordinator
    }
    
    func navigateToWalkRecord() {
        coordinator.presentFullScreen(.walkRecord)
    }
}
