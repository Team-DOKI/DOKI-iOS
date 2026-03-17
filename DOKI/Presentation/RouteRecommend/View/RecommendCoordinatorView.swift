//
//  RecommendCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum RecommendRoute: Route {
    case routeDetail(postId: Int)
    case filterSetting
}

enum FollowRouteRoute: Route {
    case followRoute
    case followRouteReview
}

enum FollowRouteReviewRoute {
    case backToRoot
}

struct RecommendCoordinatorView: View {
    
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject var recommendCoordinator: Coordinator<RecommendRoute>
    @StateObject var followRouteCoordinator: Coordinator<FollowRouteRoute>
    
    @StateObject var recommendViewModel: RecommendViewModel
    
    @StateObject var routeDetailViewModel: RouteDetailViewModel
    @StateObject var filterSettingViewModel: FilterSettingViewModel
    
    @StateObject var followRouteViewModel: FollowRouteViewModel
    @StateObject var followRouteReviewViewModel: FollowRouteReviewViewModel
    
    
    init(
        recommendCoordinator: Coordinator<RecommendRoute> = Coordinator(),
        followCoordinator: Coordinator<FollowRouteRoute> = Coordinator(),
        viewModelFactory: AppDIContainer.ViewModelFactory
    ) {
        
        self._recommendCoordinator = StateObject(wrappedValue: recommendCoordinator)
        self._followRouteCoordinator = StateObject(wrappedValue: followCoordinator)
        self._recommendViewModel = StateObject(
            wrappedValue: viewModelFactory.makeRecommendViewModel(recommendCoordinator)
        )
        self._routeDetailViewModel = StateObject(
            wrappedValue: viewModelFactory.makeRouteDetailViewModel()
        )
        self._filterSettingViewModel = StateObject(
            wrappedValue: viewModelFactory.makeFilterSettingViewModel()
        )
        self._followRouteViewModel = StateObject(
            wrappedValue: viewModelFactory.makeFollowRouteViewModel()
        )
        self._followRouteReviewViewModel = StateObject(
            wrappedValue: viewModelFactory.makeFollowRouteReviewViewModel()
        )
    }
    
    
    var body: some View {
        NavigationStack(path: $recommendCoordinator.path) {
            RouteRecommendView(viewModel: recommendViewModel)
                .navigationDestination(for: RecommendRoute.self) { destination in
                    switch destination {
                    case .routeDetail(let postId):
                        RouteDetailView(viewModel: makeRouteDetailViewModel(postId))
                        
                    case .filterSetting:
                        FilterSettingView(viewModel: filterSettingViewModel)
                    }
                }
                .fullScreenCover(
                    item: $followRouteCoordinator.fullScreenCover,
                    onDismiss: {
                        followRouteCoordinator.clearStack()
                    }
                ) { _ in
                    NavigationStack(path: $followRouteCoordinator.fullScreenPath) {
                        FollowRouteView(viewModel: followRouteViewModel)
                            .navigationDestination(for: FollowRouteRoute.self) { destination in
                                switch destination {
                                case .followRoute:
                                    FollowRouteView(viewModel: followRouteViewModel)
                                    
                                case .followRouteReview:
                                    FollowRouteReviewView(viewModel: followRouteReviewViewModel)
                                }
                            }
                    }
                }
        }
        .onChange(of: recommendCoordinator.path) { path in
            tabBarState.isHidden = !path.isEmpty
        }
        .onAppear {
            bindAction()
        }
    }
}

private extension RecommendCoordinatorView {
    func bindAction() {
        recommendViewModel.navigationAction = { destination in
            switch destination {
            case .filterSetting:
                if !recommendViewModel.filterOptions.isEmpty {
                    filterSettingViewModel.selectedFilterOptions =
                    recommendViewModel.filterOptions
                }
                
            case .routeDetail(let routeId):
                recommendCoordinator.push(.routeDetail(postId: routeId))
            }
        }
        
        filterSettingViewModel.navigationAction = { destination in
            switch destination {
            case .back:
                recommendCoordinator.pop()
                
            case .saveOption(let selectedOption):
                recommendViewModel.filterOptions = selectedOption
                recommendViewModel.selectedFilterOption =
                selectedOption.flatMap { $0.options }
                
                recommendCoordinator.pop()
            }
        }
        
        routeDetailViewModel.navigationAction = { destination in
            switch destination {
            case .back:
                recommendCoordinator.pop()
                
            case .followRoute(let routeId):
                followRouteViewModel.setRoute(routeId)
                
                followRouteCoordinator.presentFullScreen(.followRoute)
            }
        }
        
        followRouteViewModel.navigationAction = { destination in
            switch destination {
            case .followRouteReview:
                followRouteCoordinator.push(.followRouteReview)
                
            default:
                break
            }
        }
        
        followRouteReviewViewModel.navigationAction = { destination in
            switch destination {
            case .backToRoot:
                followRouteCoordinator.dismiss()
            }
        }
    }
    
    private func makeRouteDetailViewModel(_ postId: Int) -> RouteDetailViewModel {
        let viewModel = RouteDetailViewModel(
            postAPIService: PostAPIService(),
            postId: postId
        )
        
        viewModel.navigationAction = { destination in
            switch destination {
            case .back:
                recommendCoordinator.pop()
            case .followRoute(let routeId):
                followRouteViewModel.setRoute(routeId)
                
                followRouteCoordinator.presentFullScreen(.followRoute)
            }
        }
        
        return viewModel
    }
}
