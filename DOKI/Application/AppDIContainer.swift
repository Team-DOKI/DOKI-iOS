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
        func makeHomeViewModel() -> HomeViewModel {
            let homeCoordinator = Coordinator<HomeRoute>()
            return HomeViewModel()
        }
        
        func makeWalkRecordViewModel() -> WalkRecordViewModel {
            return WalkRecordViewModel()
        }
        
        func makeWalkReviewViewModel() -> WalkReviewViewModel {
            return WalkReviewViewModel()
        }
        
        func makeWalkResultViewModel() -> WalkResultViewModel {
            return WalkResultViewModel()
        }
        
        func makeLoginViewModel(_ coordinator: Coordinator<LoginRoute>) -> LoginViewModel {
            return LoginViewModel(loginCoordinator: coordinator)
        }
        
        func makeRecommendViewModel(_ coordinator: Coordinator<RecommendRoute>) -> RecommendViewModel {
            return RecommendViewModel(coordinator: coordinator)
        }
        
        func makeCourseDetailViewModel() -> RouteDetailViewModel {
            return RouteDetailViewModel()
        }
        
        func makeMyPageViewModel() -> MyPageViewModel {
            return MyPageViewModel()
        }
        
        func makeMyProfileViewModel() -> MyProfileViewModel {
            return MyProfileViewModel()
        }
        
        func makeRegisterViewModel() -> RegisterViewModel {
            return RegisterViewModel()
        }
        
        func makePetProfileViewModel() -> PetProfileViewModel {
            return PetProfileViewModel()
        }
        
        func makeFilterSettingViewModel() -> FilterSettingViewModel {
            return FilterSettingViewModel()
        }
        
        func makeMyWalkRecordViewModel() -> MyWalkRecordViewModel {
            return MyWalkRecordViewModel()
        }
        
        func makeMySavedWalkViewModel() -> MySavedWalkViewModel {
            return MySavedWalkViewModel()
        }
    }
}
