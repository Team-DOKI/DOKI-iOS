//
//  WalkResultViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkResultViewModel: ObservableObject {
    var navigationAction: ((WalkResultRoute)->())?
    
    func navigateToWalkReview() {
        navigationAction?(.walkReview)
    }
}
