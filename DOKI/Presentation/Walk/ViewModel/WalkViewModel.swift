//
//  WalkViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkViewModel: ObservableObject {
    private let coordinator: Coordinator<WalkRecordRoute>
    
    init(coordinator: Coordinator<WalkRecordRoute>) {
        self.coordinator = coordinator
    }

    func navigateToWalkRecord() {
        coordinator.presentFullScreen(.walkRecord)
    }
}
