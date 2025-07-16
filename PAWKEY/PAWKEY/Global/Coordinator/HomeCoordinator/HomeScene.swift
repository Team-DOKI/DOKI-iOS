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
    case acvitiyAreaMap(regionId: Int)
    case sharedCourseDetail(id: Int)
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .home:
            let viewModel = HomeViewModel()
            HomeView(viewModel: viewModel)
            
        case .changeMyArea:
            ChangeActivityAreaView(viewModel: ChangeActivityAreaViewModel())
            
        case .acvitiyAreaMap(let regionId):
            let viewModel = ActivityAreaMapViewModel(regionId: regionId)
            ActivityAreaMapView(viewModel: viewModel)
            
        case let .sharedCourseDetail(id):
            let viewModel = CourseDetailViewModel(postId: id)
            CourseDetailView(viewModel: viewModel)
        }
    }
}
