//
//  CourseDetailViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum CourseDetailRoute {
    case back
}

class CourseDetailViewModel: ObservableObject {
    var id: Int = 0
    
    var navigationAction: ((CourseDetailRoute)->())?
    
    func setNumber(id: Int) {
        self.id = id
    }
    
    func navigateToBack() {
        navigationAction?(.back)
    }
}
