//
//  WalkScene.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

enum WalkScene: AppScene {
    case courseList
    case courseDetail(postId: Int)
    case walkCompletion(distance: Double, elapsedTime: String, stepCount: Int, snapshot: UIImage?, routeId: Int)
    case archive(routeId: Int)
    case sharedWalkCompletion(distance: Double, elapsedTime: String, stepCount: Int, routeId: Int)
    case reviewWrite(routeId: Int)
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .courseList:
            MapAndListView()
            
        case .courseDetail(let postId):
            let viewModel = CourseDetailViewModel(postId: postId)
            CourseDetailWrapperView(viewModel: viewModel)            
        case .walkCompletion(let distance, let elapsedTime, let stepCount, let snapshot, let routeId):
            let viewModel = WalkCompletionViewModel(
                distance: distance,
                elapsedTime: elapsedTime,
                stepCount: stepCount,
                snapshot: snapshot,
                routeId: routeId
            )
            WalkCompletionView(viewModel: viewModel)
            
        case .archive(let routeId):
            let viewModel = ArchiveViewModel(routeId: routeId)
            ArchiveView(viewModel: viewModel)
            
        case .sharedWalkCompletion(let distance, let elapsedTime, let stepCount, let routeId):
            let viewModel = SharedWalkCompletionViewModel(
                distance: distance,
                elapsedTime: elapsedTime,
                stepCount: stepCount,
                routeId: routeId
            )
            SharedWalkCompletionView(viewModel: viewModel)
            
        case .reviewWrite(let routeId):
            let viewModel = ReviewWriteViewModel(routeId: routeId)
            ReviewWriteView(viewModel: viewModel)
        }
    }
}
