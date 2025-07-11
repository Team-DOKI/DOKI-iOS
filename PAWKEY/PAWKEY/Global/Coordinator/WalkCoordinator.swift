//
//  WalkCoordinator.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct WalkCoordinator: View {
    @EnvironmentObject var router: Coordinator<WalkScreen>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MapAndListView()
                .navigationDestination(for: WalkScreen.self) { screen in
                    build(screen: screen)
                        .toolbar(.hidden)
                }
        }
    }
    
    @ViewBuilder
    private func build(screen: WalkScreen) -> some View {
        switch screen {
        case .courseList:
            MapAndListView()
        case .courseDetail(let viewModel):
            CourseDetailView(viewModel: viewModel)
            //        case .walkCourse:
            //            WalkCourseView()
        case .walkCompletion(let distance, let elapsedTime, let stepCount, let snapshot):
            WalkCompletionView(
                distance: distance,
                elapsedTime: elapsedTime,
                stepCount: stepCount,
                snapshot: snapshot
            )
        case .archive(let snapshot):
                ArchiveView(snapshot: snapshot)
            
        case .sharedWalkCourse(let id):
            SharedWalkCourseView(sharedCourseId: id)
        case .sharedWalkCompletion(let id):
            SharedWalkCompletionView(sharedWalkId: id)
        case .reviewWrite(let id):
            ReviewWriteView(reviewId: id)
        }
    }
}
