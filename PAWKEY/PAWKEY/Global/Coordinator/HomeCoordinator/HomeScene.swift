//
//  HomeScreen.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

enum HomeScene: AppScene {
    case home
    case changeMyArea
    case acvitiyAreaMap
    case sharedCourseDetail(CourseDetailViewModel)
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .home:
            HomeView()
        case .changeMyArea:
            ChangeActivityAreaView(viewModel: ChangeActivityAreaViewModel())
        case .acvitiyAreaMap:
            let viewModel = ActivityAreaMapViewModel()
            ActivityAreaMapView(viewModel: viewModel)
        case .sharedCourseDetail(let viewModel):
            CourseDetailView(viewModel: viewModel)
        }
    }
}
