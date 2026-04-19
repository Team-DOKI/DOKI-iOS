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

// MARK: - RouteDetail 컨테이너 뷰
// navigationDestination이 리렌더링될 때마다 makeRouteDetailViewModel이 호출되어
// ViewModel이 초기화되는 버그를 방지하기 위해 @StateObject로 ViewModel을 소유하는 컨테이너 사용
private struct RouteDetailContainerView: View {
    @StateObject var viewModel: RouteDetailViewModel

    init(postId: Int, navigationAction: @escaping (RouteDetailRoute) -> Void) {
        let vm = RouteDetailViewModel(postAPIService: PostAPIService(), postId: postId)
        vm.navigationAction = navigationAction
        self._viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        RouteDetailView(viewModel: viewModel)
    }
}

struct RecommendCoordinatorView: View {

    @EnvironmentObject var tabBarState: TabBarState

    @StateObject var recommendCoordinator: Coordinator<RecommendRoute>
    @StateObject var followRouteCoordinator: Coordinator<FollowRouteRoute>

    @StateObject var recommendViewModel: RecommendViewModel

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
                        RouteDetailContainerView(
                            postId: postId,
                            navigationAction: { [self] route in
                                switch route {
                                case .back:
                                    recommendCoordinator.pop()
                                case .followRoute(let routeId, let postId, let address):
                                    followRouteViewModel.setRoute(routeId)
                                    followRouteReviewViewModel.setup(postId: postId, routeId: routeId, address: address)
                                    followRouteCoordinator.presentFullScreen(.followRoute)
                                }
                            }
                        )

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
                filterSettingViewModel.focusedFilterType = recommendViewModel.pendingFocusedFilterType
                recommendViewModel.pendingFocusedFilterType = nil

            case .routeDetail(let routeId):
                recommendCoordinator.push(.routeDetail(postId: routeId))
            }
        }

        filterSettingViewModel.navigationAction = { destination in
            switch destination {
            case .back:
                recommendCoordinator.pop()

            case .saveOption(let selectedOption):
                let hasAnyActive = selectedOption.contains { $0.options.contains { $0.isActive } }

                recommendViewModel.filterOptions = hasAnyActive ? selectedOption : []
                recommendCoordinator.pop()
            }
        }

        followRouteViewModel.navigationAction = { destination in
            switch destination {
            case .followRouteReview:
                followRouteReviewViewModel.setWalkData(
                    distanceString: followRouteViewModel.distanceString,
                    elapsedTimeString: followRouteViewModel.elapsedTimeString,
                    stepString: followRouteViewModel.stepString,
                    startDate: followRouteViewModel.startDate
                )
                followRouteCoordinator.push(.followRouteReview)

            default:
                break
            }
        }

        followRouteReviewViewModel.navigationAction = { destination in
            switch destination {
            case .backToRoot:
                // fullScreenCover만 닫으면 RouteDetailView로 돌아옴
                followRouteCoordinator.dismiss()
            }
        }
    }
}
