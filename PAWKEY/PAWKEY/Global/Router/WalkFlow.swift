//
//  WalkFlow.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct WalkFlow: View {
    @EnvironmentObject var router: TabRouter<WalkScreen>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            CourseListView()
                .navigationDestination(for: WalkScreen.self) { screen in
                    build(screen: screen)
                }
        }
    }
    
    @ViewBuilder
    private func build(screen: WalkScreen) -> some View {
        switch screen {
        case .courseList:
            CourseListView()
        case .courseDetail(let id):
            CourseDetailView(courseId: id)
            
//        case .walkCourse:
//            WalkCourseView()
        case .walkCompletion(let id):
            WalkCompletionView(courseId: id)
        case .archive(let id):
            ArchiveView(archiveId: id)
            
        case .sharedWalkCourse(let id):
            SharedWalkCourseView(sharedCourseId: id)
        case .sharedWalkCompletion(let id):
            SharedWalkCompletionView(sharedWalkId: id)
        case .reviewWrite(let id):
            ReviewWriteView(reviewId: id)
        }
    }
}
