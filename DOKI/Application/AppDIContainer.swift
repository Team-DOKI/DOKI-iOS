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
            return WalkReviewViewModel(
                filterAPIService: FilterAPIService(),
                postAPIService: PostAPIService(),
                imageAPIService: ImageAPIService()
            )
        }
        
        func makeWalkResultViewModel() -> WalkResultViewModel {
            return WalkResultViewModel()
        }
        
        func makeLoginViewModel() -> LoginViewModel {
            return LoginViewModel()
        }
        
        func makeRecommendViewModel(_ coordinator: Coordinator<RecommendRoute>) -> RecommendViewModel {
            let postAPIService = PostAPIService()
            return RecommendViewModel(coordinator: coordinator, postAPIservice: postAPIService)
        }
        
        func makeRouteDetailViewModel() -> RouteDetailViewModel {
            return RouteDetailViewModel(postAPIService: PostAPIService())
        }
        
        func makeMyPageViewModel() -> MyPageViewModel {
            return MyPageViewModel()
        }
        
        func makeMyReviewsViewModel() -> MyReviewsViewModel {
            return MyReviewsViewModel()
        }
        
        func makeRegionSettingViewModel() -> RegionSettingViewModel {
            return RegionSettingViewModel()
        }
        
        func makeRegisterViewModel() -> RegisterViewModel {
            return RegisterViewModel()
        }
        
        func makeFilterSettingViewModel() -> FilterSettingViewModel {
            let filterApiServcie = FilterAPIService()
            return FilterSettingViewModel(filterAPIService: filterApiServcie)
        }
        
        func makeMyPostViewModel() -> MyPostsViewModel {
            return MyPostsViewModel()
        }
        
        func makeMyLikedPostViewModel() -> MyLikedPostsViewModel {
            return MyLikedPostsViewModel()
        }
    }
}
