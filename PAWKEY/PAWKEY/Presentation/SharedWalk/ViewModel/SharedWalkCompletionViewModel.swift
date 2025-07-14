//
//  SharedWalkCompletionViewModel.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

final class SharedWalkCompletionViewModel: ObservableObject {
    let distance: Double
    let elapsedTime: String
    let stepCount: Int
    let snapshot: UIImage?
    
    init(distance: Double, elapsedTime: String, stepCount: Int, snapshot: UIImage?) {
        self.distance = distance
        self.elapsedTime = elapsedTime
        self.stepCount = stepCount
        self.snapshot = snapshot
    }
}
