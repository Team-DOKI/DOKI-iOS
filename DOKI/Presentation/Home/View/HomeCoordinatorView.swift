//
//  HomeCoordinatorView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum HomeRoute: Route {
    case walkRecord
    case courseReview
    case walkResult
}

struct HomeCoordinatorView: View {
    @StateObject var homeCoordinator: Coordinator<HomeRoute>
    @StateObject var walkRecordViewModel: WalkRecordViewModel
    @StateObject var courseReviewViewModel: CourseReviewViewModel
    @StateObject var walkResultViewModel: WalkResultViewModel
    
    private let viewModelFactory: AppDIContainer.ViewModelFactory
    
    init(homeCoordinator: Coordinator<HomeRoute> = Coordinator<HomeRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self._homeCoordinator = StateObject(wrappedValue: Coordinator<HomeRoute>())
        self._walkRecordViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkRecordViewModel())
        self._courseReviewViewModel = StateObject(wrappedValue: viewModelFactory.makeCourseReviewViewModel())
        self._walkResultViewModel = StateObject(wrappedValue: viewModelFactory.makeCourseResultViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $homeCoordinator.path) {
            HomeView(viewModel: HomeViewModel(coordinator: homeCoordinator))
                .fullScreenCover(item: $homeCoordinator.fullScreenCover, onDismiss: {
                    homeCoordinator.clearStack()
                }, content: { destination in
                    NavigationStack(path: $homeCoordinator.fullScreenPath) {
                        WalkRecordView(viewModel: walkRecordViewModel)
                            .navigationDestination(for: HomeRoute.self) { destination in
                                switch destination {
                                case .walkRecord:
                                    WalkRecordView(viewModel: walkRecordViewModel)
                                case .courseReview:
                                    CourseReviewView(viewModel: courseReviewViewModel)
                                case .walkResult:
                                    WalkResultView(viewModel: walkResultViewModel)
                                }
                            }
                    }
                })
        }
        .onAppear(perform: bindAction)
    }
    
    func bindAction() {
        walkRecordViewModel.navigationAction = { destination in
            switch destination {
            case .walkReview:
                homeCoordinator.push(.courseReview)
            }
        }
        
        courseReviewViewModel.navigationAction = { destination in
            switch destination {
            case .walkResult:
                homeCoordinator.push(.walkResult)
            }
        }                
    }
}
