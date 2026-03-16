//
//  RecommendCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum RecommendRoute: Route {
    case courseDetail(id: Int)
    case filterSetting
}

struct RecommendCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject var recommendCoordinator: Coordinator<RecommendRoute>
    @StateObject var recommendViewModel: RecommendViewModel
    @StateObject var courseDetailViewModel: RouteDetailViewModel
    @StateObject var filterSettingViewModel: FilterSettingViewModel
    
    init(recommendCoordinator: Coordinator<RecommendRoute> = Coordinator<RecommendRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._recommendCoordinator = StateObject(wrappedValue: recommendCoordinator)
        self._recommendViewModel = StateObject(wrappedValue: viewModelFactory.makeRecommendViewModel(recommendCoordinator))
        self._courseDetailViewModel = StateObject(wrappedValue: viewModelFactory.makeRouteDetailViewModel())
        self._filterSettingViewModel = StateObject(wrappedValue: viewModelFactory.makeFilterSettingViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $recommendCoordinator.path) {
            RouteRecommendView(viewModel: recommendViewModel)
                .navigationDestination(for: RecommendRoute.self) { destination in
                    switch destination {
                    case .courseDetail(let postID):
                        RouteDetailView(viewModel: makeCourseDetailViewModel(postID))
                    case .filterSetting:
                        FilterSettingView(viewModel: filterSettingViewModel)
                    }
                }
        }
        .onChange(of: recommendCoordinator.path) { path in
            tabBarState.isHidden = !path.isEmpty
        }
        .onAppear {
            recommendViewModel.navigationAction = { destination in
                switch destination {
                case .filterSetting:
                    if !recommendViewModel.filterOptions.isEmpty {                        
                        filterSettingViewModel.selectedFilterOptions = recommendViewModel.filterOptions                        
                    }
                default:
                    break
                }
            }
            courseDetailViewModel.navigationAction = { destination in
                switch destination {
                case .back:
                    recommendCoordinator.pop()
                }
            }
            filterSettingViewModel.navigationAction = { destination in
                switch destination {
                case .back:
                    recommendCoordinator.pop()
                case .saveOption(let selectedOption):                    
                    recommendViewModel.filterOptions = selectedOption
                    recommendViewModel.selectedFilterOption = selectedOption.flatMap { $0.options }
                    recommendCoordinator.pop()
                }
            }
        }
    }
    
    private func makeCourseDetailViewModel(_ postID: Int) -> RouteDetailViewModel {
        let viewModel = RouteDetailViewModel(
            postAPIService: PostAPIService(),
            postId: postID
        )

        viewModel.navigationAction = { destination in
            switch destination {
            case .back:
                recommendCoordinator.pop()
            }
        }

        return viewModel
    }
}
