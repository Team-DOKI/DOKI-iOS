//
//  WalkScene.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

enum WalkScene: AppScene {
    case courseList
    case courseDetail(CourseDetailViewModel)
    case walkCompletion(distance: Double, elapsedTime: String, stepCount: Int, snapshot: UIImage?)
    case archive(snapshot: UIImage?)
    case sharedWalkCompletion(distance: Double, elapsedTime: String, stepCount: Int, snapshot: UIImage?)
    case reviewWrite
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .courseList:
            MapAndListView()
        case .courseDetail(let viewModel):
            CourseDetailView(viewModel: viewModel)
        case .walkCompletion(let distance, let elapsedTime, let stepCount, let snapshot):
            WalkCompletionView(
                distance: distance,
                elapsedTime: elapsedTime,
                stepCount: stepCount,
                snapshot: snapshot
            )
        case .archive(let snapshot):
            ArchiveView(snapshot: snapshot)
        case .sharedWalkCompletion(let distance, let elapsedTime, let stepCount, let snapshot):
            SharedWalkCompletionView(
                distance: distance,
                elapsedTime: elapsedTime,
                stepCount: stepCount,
                snapshot: snapshot
            )
        case .reviewWrite:
            ReviewWriteView()
        }
    }
}
