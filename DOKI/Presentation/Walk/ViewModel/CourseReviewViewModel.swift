//
//  CourseReviewViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum CourseReviewRoute {
    case walkResult
}

class CourseReviewViewModel: ObservableObject {
    var navigationAction: ((CourseReviewRoute)->())?
    
    func navigateToWalkResult() {
        navigationAction?(.walkResult)
    }
}
