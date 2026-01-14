//
//  WalkCoordinatorView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum WalkRecordRoute: Route {
    case walkRecord
    case courseReview
    case walkResult
}

enum WalkRoute: Route {
    case courseDetail
}

struct WalkCoordinatorView: View {
    @StateObject var walkRecordCoordinator: Coordinator<WalkRecordRoute>
    @StateObject var walkCoordinator: Coordinator<WalkRoute>
    @StateObject var walkRecordViewModel: WalkRecordViewModel
    @StateObject var courseReviewViewModel: CourseReviewViewModel
    @StateObject var walkResultViewModel: WalkResultViewModel
    @StateObject var courseDetailViewModel = CourseDetailViewModel()
    
    private let viewModelFactory: AppDIContainer.ViewModelFactory
    
    init(walkRecordCoordinator: Coordinator<WalkRecordRoute> = Coordinator<WalkRecordRoute>(),
         walkCoordinator: Coordinator<WalkRoute> = Coordinator<WalkRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self._walkRecordCoordinator = StateObject(wrappedValue: walkRecordCoordinator)
        self._walkCoordinator = StateObject(wrappedValue: walkCoordinator)
        self._walkRecordViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkRecordViewModel())
        self._courseReviewViewModel = StateObject(wrappedValue: viewModelFactory.makeCourseReviewViewModel())
        self._walkResultViewModel = StateObject(wrappedValue: viewModelFactory.makeCourseResultViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $walkCoordinator.path) {
            WalkView(viewModel: WalkViewModel(coordinator: walkRecordCoordinator))
                .navigationDestination(for: WalkRoute.self, destination: { destination in
                    switch destination {
                    case .courseDetail:
                        CourseDetailView(viewModel: courseDetailViewModel)
                    }
                })
                .fullScreenCover(item: $walkRecordCoordinator.fullScreenCover, onDismiss: {
                    walkRecordCoordinator.clearStack()
                }, content: { destination in
                    NavigationStack(path: $walkRecordCoordinator.fullScreenPath) {
                        WalkRecordView(viewModel: walkRecordViewModel)
                            .navigationDestination(for: WalkRecordRoute.self) { destination in
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
        courseDetailViewModel.navigationAction = { destination in
            switch destination {
            case .back:
                walkCoordinator.pop()
            }
        }
        
        walkRecordViewModel.navigationAction = { destination in
            switch destination {
            case .walkReview:
                walkRecordCoordinator.push(.courseReview)
            }
        }
        
        courseReviewViewModel.navigationAction = { destination in
            switch destination {
            case .walkResult:
                walkRecordCoordinator.push(.walkResult)
            }
        }
        
        walkResultViewModel.navigationAction = { destination in
            switch destination {
            case .backToRoot:
                walkRecordCoordinator.dismiss()
            case .detail:
                // 화면 및 경로 제거
                walkRecordCoordinator.dismiss()
                walkRecordCoordinator.clearStack()
                // 디테일뷰로 이동
                walkCoordinator.push(.courseDetail)
            }
        }
    }
}

