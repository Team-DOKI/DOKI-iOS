//
//  MyPageCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum MyPageRoute: Route, Hashable {
    case userProfile
    case petProfile
    
    case myPosts
    case myLikedPosts
    case review
    
    case regionSetting
    case appInfo
    
    case dbtiStart
    case dbtiSurvey
    case dbtiResult
}

struct MyPageCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject var myPageCoordinator: Coordinator<MyPageRoute>
    
    @StateObject var myPageViewModel: MyPageViewModel
    @StateObject var myPostsViewModel: MyPostsViewModel
    @StateObject var myLikedPostsViewModel: MyLikedPostsViewModel
    
    @StateObject var dbtiViewModel = DBTIViewModel(entryContext: .myPage)
    
    init(myPageCoordinator: Coordinator<MyPageRoute> = Coordinator<MyPageRoute>(), viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._myPageCoordinator = StateObject(wrappedValue: myPageCoordinator)
        
        self._myPageViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPageViewModel())
        self._myPostsViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPostViewModel())
        self._myLikedPostsViewModel = StateObject(wrappedValue: viewModelFactory.makeMyLikedPostViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $myPageCoordinator.path) {
            MyPageView(viewModel: myPageViewModel)
                .navigationDestination(for: MyPageRoute.self) { destination in
                    switch destination {
                    case .userProfile:
                        if let userProfile = myPageViewModel.userProfile {
                            UserProfileView(
                                viewModel: UserProfileViewModel(userProfile: userProfile)
                            )
                        }
                    case .petProfile:
                        if let petProfile = myPageViewModel.petProfile {
                            PetProfileView(
                                viewModel: PetProfileViewModel(petProfile: petProfile)
                            )
                        }
                    case .myPosts:
                        MyPostsView(viewModel: myPostsViewModel)
                    case .myLikedPosts:
                        MyLikedPostsView(viewModel: myLikedPostsViewModel)
                    case .review:
                        MyReviewView()
                    case .regionSetting:
                        RegionSettingView()
                    case .appInfo:
                        AppInfoView()
                    case .dbtiStart:
                        DBTIStartView(viewModel: dbtiViewModel)
                    case .dbtiSurvey:
                        DBTISurveyView(viewModel: dbtiViewModel)
                    case .dbtiResult:
                        DBTIResultView(viewModel: dbtiViewModel)
                    }
                }
        }
        .onChange(of: myPageCoordinator.path) { path in
            tabBarState.isHidden = !path.isEmpty
        }
        .onAppear(perform: bindAction)
    }
    
    func bindAction() {
        myPageViewModel.navigationAction = { destination in
            switch destination {
            case .userProfile:
                myPageCoordinator.push(.userProfile)
            case .petProfile:
                myPageCoordinator.push(.petProfile)
            case .myPosts:
                myPageCoordinator.push(.myPosts)
            case .myLikedPosts:
                myPageCoordinator.push(.myLikedPosts)
            case .review:
                myPageCoordinator.push(.review)
            case .regionSetting:
                myPageCoordinator.push(.regionSetting)
            case .appInfo:
                myPageCoordinator.push(.appInfo)
            case .dbtiStart:
                myPageCoordinator.push(.dbtiStart)
            case .dbtiSurvey:
                myPageCoordinator.push(.dbtiSurvey)
            case .dbtiResult:
                myPageCoordinator.push(.dbtiResult)
            }
        }
        
        dbtiViewModel.navigationAction = { action in
            switch action {
            case .dbtiStart:
                myPageCoordinator.push(.dbtiStart)
            case .dbtiSurvey:
                myPageCoordinator.push(.dbtiSurvey)
            case .dbtiResult:
                myPageCoordinator.push(.dbtiResult)
            case .dbtiRestart:
                myPageCoordinator.popToRoot()
                myPageCoordinator.push(.dbtiSurvey)
            case .dbtiFinish:
                myPageCoordinator.popToRoot()
            }
        }
    }
}

