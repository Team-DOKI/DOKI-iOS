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
    case myReviews

    case regionSetting
    case appInfo

    case dbtiStart
    case dbtiSurvey
    case dbtiResult

    case routeDetail(postId: Int)
}

struct MyPageCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject var myPageCoordinator: Coordinator<MyPageRoute>
    @StateObject var followRouteCoordinator: Coordinator<FollowRouteRoute>

    @StateObject var myPageViewModel: MyPageViewModel

    @StateObject var myPostsViewModel: MyPostsViewModel
    @StateObject var myLikedPostsViewModel: MyLikedPostsViewModel
    @StateObject var myReviewsViewModel: MyReviewsViewModel

    @StateObject var regionSettingViewModel: RegionSettingViewModel

    @StateObject var followRouteViewModel: FollowRouteViewModel
    @StateObject var followRouteReviewViewModel: FollowRouteReviewViewModel

    @StateObject var dbtiViewModel = DBTIViewModel(entryContext: .myPage)

    init(myPageCoordinator: Coordinator<MyPageRoute> = Coordinator<MyPageRoute>(), viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._myPageCoordinator = StateObject(wrappedValue: myPageCoordinator)
        self._followRouteCoordinator = StateObject(wrappedValue: Coordinator<FollowRouteRoute>())

        self._myPageViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPageViewModel())

        self._myPostsViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPostViewModel())
        self._myLikedPostsViewModel = StateObject(wrappedValue: viewModelFactory.makeMyLikedPostViewModel())
        self._myReviewsViewModel = StateObject(wrappedValue: viewModelFactory.makeMyReviewsViewModel())
        self._regionSettingViewModel = StateObject(wrappedValue: viewModelFactory.makeRegionSettingViewModel())

        self._followRouteViewModel = StateObject(wrappedValue: viewModelFactory.makeFollowRouteViewModel())
        self._followRouteReviewViewModel = StateObject(wrappedValue: viewModelFactory.makeFollowRouteReviewViewModel())
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
                    case .myReviews:
                        MyReviewsView(viewModel: myReviewsViewModel)
                    case .regionSetting:
                        RegionSettingView(viewModel: regionSettingViewModel)
                    case .appInfo:
                        AppInfoView()
                    case .dbtiStart:
                        DBTIStartView(viewModel: dbtiViewModel)
                    case .dbtiSurvey:
                        DBTISurveyView(viewModel: dbtiViewModel)
                    case .dbtiResult:
                        DBTIResultView(viewModel: dbtiViewModel)
                    case .routeDetail(let postId):
                        RouteDetailView(viewModel: makeRouteDetailViewModel(postId))
                    }
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
            case .myReviews:
                myPageCoordinator.push(.myReviews)
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
            case .routeDetail(postId: let postId):
                myPageCoordinator.push(.routeDetail(postId: postId))
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

        myPostsViewModel.navigationAction = { postId in
            myPageCoordinator.push(.routeDetail(postId: postId))
        }

        myLikedPostsViewModel.navigationAction = { postId in
            myPageCoordinator.push(.routeDetail(postId: postId))
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
        let viewModel = RouteDetailViewModel(postAPIService: PostAPIService(), postId: postId)

        viewModel.navigationAction = { destination in
            switch destination {
            case .back:
                myPageCoordinator.pop()
            case .followRoute(let routeId):
                followRouteViewModel.setRoute(routeId)
                followRouteCoordinator.presentFullScreen(.followRoute)
            }
        }

        return viewModel
    }
}

