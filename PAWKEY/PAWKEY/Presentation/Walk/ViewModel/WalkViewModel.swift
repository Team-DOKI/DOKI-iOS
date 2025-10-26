//
//  WalkViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkViewModel: ObservableObject {
    private let coordinator: Coordinator<WalkRoute>
    
    init(coordinator: Coordinator<WalkRoute>) {
        self.coordinator = coordinator
    }

    func navigateToWalkRecord() {
        coordinator.presentFullScreen(.walkRecord)
    }
}
