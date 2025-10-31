//
//  WalkResultViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum WalkResultRoute {
    case backToRoot
}

class WalkResultViewModel: ObservableObject {
    var navigationAction: ((WalkResultRoute)->())?
    
    func navigateBackToRoot() {
        navigationAction?(.backToRoot)
    }
}
