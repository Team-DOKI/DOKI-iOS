//
//  RecommendCoordinatorView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum RecommendRoute: Route {
    case courseDetail(id: Int)
}

struct RecommendCoordinatorView: View {
    @StateObject var recommendCoordinator: Coordinator<RecommendRoute>
    @StateObject var recommendViewModel: RecommendViewModel
    @StateObject var courseDetailViewModel: CourseDetailViewModel
    
    init(recommendCoordinator: Coordinator<RecommendRoute> = Coordinator<RecommendRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._recommendCoordinator = StateObject(wrappedValue: recommendCoordinator)
        self._recommendViewModel = StateObject(wrappedValue: viewModelFactory.makeRecommendViewModel(recommendCoordinator))
        self._courseDetailViewModel = StateObject(wrappedValue: viewModelFactory.makeCourseDetailViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $recommendCoordinator.path) {
            RouteRecommendView(viewModel: recommendViewModel)
                .navigationDestination(for: RecommendRoute.self) { destination in
                    switch destination {
                    case .courseDetail(let id):
                        courseDetailViewModel.setNumber(id: id)
                        return CourseDetailView(viewModel: courseDetailViewModel)
                    }
                }
        }
        .onAppear {
            courseDetailViewModel.navigationAction = { destination in
                switch destination {
                case .back:
                    recommendCoordinator.pop()
                }
            }
        }
    }
}

//#Preview {
//    RecommendCoordinatorView()
//}
