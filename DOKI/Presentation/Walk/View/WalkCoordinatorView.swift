//
//  WalkCoordinatorView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum WalkRoute: Route {
    case walkRecord
    case courseReview
    case walkResult
}

struct WalkCoordinatorView: View {
    @StateObject var walkCoordinator: Coordinator<WalkRoute>
    @StateObject var walkRecordViewModel: WalkRecordViewModel
    @StateObject var courseReviewViewModel: CourseReviewViewModel
    @StateObject var walkResultViewModel: WalkResultViewModel
    
    private let viewModelFactory: AppDIContainer.ViewModelFactory
    
    init(walkCoordinator: Coordinator<WalkRoute> = Coordinator<WalkRoute>(),
         viewModelFactory: AppDIContainer.ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self._walkCoordinator = StateObject(wrappedValue: Coordinator<WalkRoute>())
        self._walkRecordViewModel = StateObject(wrappedValue: viewModelFactory.makeWalkRecordViewModel())
        self._courseReviewViewModel = StateObject(wrappedValue: viewModelFactory.makeCourseReviewViewModel())
        self._walkResultViewModel = StateObject(wrappedValue: viewModelFactory.makeCourseResultViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $walkCoordinator.path) {
            WalkView(viewModel: WalkViewModel(coordinator: walkCoordinator))
                .fullScreenCover(item: $walkCoordinator.fullScreenCover, onDismiss: {
                    walkCoordinator.clearStack()
                }, content: { destination in
                    NavigationStack(path: $walkCoordinator.fullScreenPath) {
                        WalkRecordView(viewModel: walkRecordViewModel)
                            .navigationDestination(for: WalkRoute.self) { destination in
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
                walkCoordinator.push(.courseReview)
            }
        }
        
        courseReviewViewModel.navigationAction = { destination in
            switch destination {
            case .walkResult:
                walkCoordinator.push(.walkResult)
            }
        }
        
        walkResultViewModel.navigationAction = { destination in
            switch destination {
            case .backToRoot:
                walkCoordinator.dismiss()            
            }
        }
    }
}

