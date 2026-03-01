//
//  AppDIContainer.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

final class AppDIContainer: ObservableObject {
    var viewModelFactory: ViewModelFactory
    
    init(viewModelFactory: ViewModelFactory = ViewModelFactory()) {
        self.viewModelFactory = viewModelFactory
    }
}

extension AppDIContainer {
    struct ViewModelFactory {
        func makeWalkRecordViewModel() -> WalkRecordViewModel {
            return WalkRecordViewModel()
        }
        
        func makeWalkReviewViewModel() -> WalkReviewViewModel {
            return WalkReviewViewModel()
        }
        
        func makeWalkResultViewModel() -> WalkResultViewModel {
            return WalkResultViewModel()
        }
        
        func makeLoginViewModel() -> LoginViewModel {
            return LoginViewModel()
        }
        
        func makeRecommendViewModel(_ coordinator: Coordinator<RecommendRoute>) -> RecommendViewModel {
            return RecommendViewModel(coordinator: coordinator)
        }
        
        func makeRouteDetailViewModel() -> RouteDetailViewModel {
            return RouteDetailViewModel()
        }
        
        func makeMyPageViewModel() -> MyPageViewModel {
            return MyPageViewModel()
        }
        
        func makeMyReviewsViewModel() -> MyReviewsViewModel {
            return MyReviewsViewModel()
        }
        
        func makeRegisterViewModel() -> RegisterViewModel {
            return RegisterViewModel()
        }
        
        func makeFilterSettingViewModel() -> FilterSettingViewModel {
            return FilterSettingViewModel()
        }
        
        func makeMyPostViewModel() -> MyPostsViewModel {
            return MyPostsViewModel()
        }
        
        func makeMyLikedPostViewModel() -> MyLikedPostsViewModel {
            return MyLikedPostsViewModel()
        }
    }
}
