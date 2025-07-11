//
//  HomeCoordinator.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct HomeCoordinator: View {
    @EnvironmentObject var router: Coordinator<HomeScreen>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: HomeScreen.self) { screen in
                    build(screen: screen)
                        .toolbar(.hidden)
                }
        }
    }
    
    @ViewBuilder
    private func build(screen: HomeScreen) -> some View {
        switch screen {
        case .home:
            HomeView()
        case .changeMyArea:
            ChangeActivityAreaView(viewModel: ChangeActivityAreaViewModel())
        case .acvitiyAreaMap:
            ActivityAreaMapView()
        case .sharedCourseDetail:
            SharedCourseDetailView(viewModel: CourseDetailViewModel())
        }
    }
}
