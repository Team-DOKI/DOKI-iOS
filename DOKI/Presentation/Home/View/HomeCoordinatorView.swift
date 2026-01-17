//
//  HomeCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum HomeRoute: Route {
    case routeDetail
}

enum HomeAction {
    case walkRecord
}

struct HomeCoordinatorView: View {
    @StateObject var homeCoordinator: Coordinator<HomeRoute>
    @StateObject var walkRecordCoordinator: Coordinator<WalkRecordRoute>
    @StateObject var walkRecordViewModel: WalkRecordViewModel
    @StateObject var walkResultViewModel: WalkResultViewModel
    @StateObject var walkReviewViewModel: WalkReviewViewModel
    @StateObject var routeDetailViewModel = RouteDetailViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    
    private let viewModelFactory: AppDIContainer.ViewModelFactory
    
    init(homeCoordinator: Coordinator<HomeRoute> = Coordinator<HomeRoute>(),
         walkRecordCoordinator: Coordinator<WalkRecordRoute> = Coordinator<WalkRecordRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self._homeCoordinator = StateObject(wrappedValue: Coordinator<HomeRoute>())
        self._walkRecordCoordinator = StateObject(wrappedValue: Coordinator<WalkRecordRoute>())
        self._walkRecordViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkRecordViewModel())
        self._walkResultViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkResultViewModel())
        self._walkReviewViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkReviewViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $homeCoordinator.path) {
            HomeView(viewModel: homeViewModel)
                .navigationDestination(for: HomeRoute.self) { destination in
                    switch destination {
                    case .routeDetail:
                        RouteDetailView(viewModel: routeDetailViewModel)
                    }
                }
                .fullScreenCover(item: $walkRecordCoordinator.fullScreenCover, onDismiss: {
                    walkRecordCoordinator.clearStack()
                }, content: { destination in
                    NavigationStack(path: $walkRecordCoordinator.fullScreenPath) {
                        WalkRecordView(viewModel: walkRecordViewModel)
                            .navigationDestination(for: WalkRecordRoute.self) { destination in
                                switch destination {
                                case .walkRecord:
                                    WalkRecordView(viewModel: walkRecordViewModel)
                                case .walkResult:
                                    WalkResultView(viewModel: walkResultViewModel)
                                case .walkReview:
                                    WalkReviewView(viewModel: walkReviewViewModel)
                                }
                            }
                    }
                })
        }
        .onAppear(perform: bindAction)
    }
    
    func bindAction() {
        
        homeViewModel.navigationAction = { destination in
            switch destination {
            case .walkRecord:
                walkRecordCoordinator.presentFullScreen(.walkRecord)
            }
        }
        
        walkRecordViewModel.navigationAction = { destination in
            switch destination {
            case .walkRecord:
                walkRecordCoordinator.push(.walkRecord)
            case .walkResult:
                walkRecordCoordinator.push(.walkResult)
            case .walkReview:
                walkRecordCoordinator.push(.walkReview)
            }
        }
        
        walkResultViewModel.navigationAction = { destination in
            switch destination {
            case .walkReview:
                walkRecordCoordinator.push(.walkReview)
            }
        }
        
        walkReviewViewModel.navigationAction = { destination in
            switch destination {
            case .backToRoot:
                walkRecordCoordinator.dismiss()
            case .routeDetail:
                walkRecordCoordinator.dismiss()
                homeCoordinator.push(.routeDetail)
            }
        }
        
        routeDetailViewModel.navigationAction = { destination in
            switch destination {
            case .back:
                homeCoordinator.pop()
            }
        }
    }
}
