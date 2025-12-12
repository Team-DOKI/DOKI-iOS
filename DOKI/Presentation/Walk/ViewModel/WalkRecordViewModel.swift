//
//  StartWalkViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum WalkReviewRoute {
    case walkResult
}

class WalkRecordViewModel: ObservableObject {
    var navigationAction: ((WalkReviewRoute)->())?
    
    func navigateToWalkResult() {
        navigationAction?(.walkResult)
    }
}
