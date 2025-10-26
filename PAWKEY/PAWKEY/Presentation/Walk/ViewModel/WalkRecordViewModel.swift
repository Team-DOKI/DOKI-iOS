//
//  StartWalkViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum WalkReviewRoute {
    case walkReview
}

class WalkRecordViewModel: ObservableObject {
    var navigationAction: ((WalkReviewRoute)->())?
    
    func navigateToWalkReview() {
        navigationAction?(.walkReview)
    }
}
