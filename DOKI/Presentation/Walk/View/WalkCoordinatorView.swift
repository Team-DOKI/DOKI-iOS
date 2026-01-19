//
//  WalkCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum WalkReadyRoute: Route {
    case routeDetail
}

enum WalkRecordRoute: Route {
    case walkRecord
    case walkResult
    case walkReview
}

enum WalkResultRoute: Route {
    case walkReview
}

enum WalkReviewRoute {
    case backToRoot
    case routeDetail
}

struct WalkCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject var walkReadyCoordinator: Coordinator<WalkReadyRoute>
    @StateObject var walkRecordCoordinator: Coordinator<WalkRecordRoute>
    @StateObject var walkRecordViewModel: WalkRecordViewModel
    @StateObject var walkResultViewModel: WalkResultViewModel
    @StateObject var walkReviewViewModel: WalkReviewViewModel
    @StateObject var routeDetailViewModel = RouteDetailViewModel()
    
    private let viewModelFactory: AppDIContainer.ViewModelFactory
    
    init(walkReadyCoordinator: Coordinator<WalkReadyRoute> = Coordinator<WalkReadyRoute>(),
         walkRecordCoordinator: Coordinator<WalkRecordRoute> = Coordinator<WalkRecordRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self._walkReadyCoordinator = StateObject(wrappedValue: walkReadyCoordinator)
        self._walkRecordCoordinator = StateObject(wrappedValue: walkRecordCoordinator)
        self._walkRecordViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkRecordViewModel())
        self._walkResultViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkResultViewModel())
        self._walkReviewViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkReviewViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $walkReadyCoordinator.path) {
            WalkReadyView(viewModel: WalkReadyViewModel(coordinator: walkRecordCoordinator))
                .navigationDestination(for: WalkReadyRoute.self) { destination in
                    switch destination {
                    case .routeDetail:
                        RouteDetailView(viewModel: routeDetailViewModel)
                            .onAppear { tabBarState.isHidden = true }
                            .onDisappear { tabBarState.isHidden = false }
                    }
                }
                .fullScreenCover(item: $walkRecordCoordinator.fullScreenCover, onDismiss: {
                    walkRecordCoordinator.clearStack()
                }, content: { _ in
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
                walkReadyCoordinator.push(.routeDetail)
            }
        }
        
        routeDetailViewModel.navigationAction = { destination in
            switch destination {
            case .back:
                walkReadyCoordinator.pop()
            }
        }
    }
}
