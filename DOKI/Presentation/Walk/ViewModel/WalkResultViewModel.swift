//
//  WalkResultViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkResultViewModel: ObservableObject {
    
    @Published var distance: Double = 0
    @Published var elapsedSeconds: Int = 0
    @Published var stepCount: Int = 0
    
    @Published var petName: String = ""
    @Published var petImageUrl: String = ""
    @Published var startedAt: String = ""
    
    var distanceString: String {
        String(format: "%.2f", distance / 1000)
    }
    
    var elapsedTimeString: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var stepString: String {
        "\(stepCount)"
    }
    
    func update(with data: WalkResultData) {
        self.distance = data.distance
        self.elapsedSeconds = data.elapsedSeconds
        self.stepCount = data.stepCount
    }
    
    func updateFinishResponse(_ response: WalkFinishResponse) {
        petName = response.petProfile.name
        petImageUrl = response.petProfile.imageUrl
        startedAt = response.walkInfo.startedAt
    }
    
    var navigationAction: ((WalkResultRoute)->())?
    
    func navigateToWalkReview() {
        navigationAction?(.walkReview)
    }
}
