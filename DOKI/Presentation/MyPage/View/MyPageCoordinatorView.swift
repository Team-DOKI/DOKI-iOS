//
//  MyPageCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum MyPageRoute: Route, Hashable {
    case myProfile
    case petProfile
    
    case myWalkRecord
    case savedWalk
    case review
    
    case activityAreaSetting
    case appInfo
    
    case dbtiStart
    case dbtiSurvey
    case dbtiResult
}

struct MyPageCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject var myPageCoordinator: Coordinator<MyPageRoute>
    @StateObject var myPageViewModel: MyPageViewModel
    @StateObject var petProfileViewModel:  PetProfileViewModel
    @StateObject var myWalkRecordViewModel: MyWalkRecordViewModel
    @StateObject var mySavedWalkViewModel: MySavedWalkViewModel
    @StateObject var dbtiViewModel = DBTIViewModel(entryContext: .myPage)
    
    init(myPageCoordinator: Coordinator<MyPageRoute> = Coordinator<MyPageRoute>(), viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._myPageCoordinator = StateObject(wrappedValue: myPageCoordinator)
        self._myPageViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPageViewModel())
        self._petProfileViewModel = StateObject(wrappedValue: viewModelFactory.makePetProfileViewModel())
        self._myWalkRecordViewModel = StateObject(wrappedValue: viewModelFactory.makeMyWalkRecordViewModel())
        self._mySavedWalkViewModel = StateObject(wrappedValue: viewModelFactory.makeMySavedWalkViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $myPageCoordinator.path) {
            MyPageView(viewModel: myPageViewModel)
                .navigationDestination(for: MyPageRoute.self) { destination in
                    switch destination {
                    case .myProfile:
                        if let userProfile = myPageViewModel.userProfile {
                            MyProfileView(
                                viewModel: MyProfileViewModel(userProfile: userProfile)
                            )
                        }
                    case .petProfile:
                        PetProfileView(viewModel: petProfileViewModel)
                    case .myWalkRecord:
                        MyWalkRecordView(viewModel: myWalkRecordViewModel)
                    case .savedWalk:
                        MySavedWalkView(viewModel: mySavedWalkViewModel)
                    case .review:
                        MyReviewView()
                    case .activityAreaSetting:
                        ActivityAreaSettingView()
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
            case .myProfile:
                myPageCoordinator.push(.myProfile)
            case .petProfile:
                myPageCoordinator.push(.petProfile)
            case .myWalkRecord:
                myPageCoordinator.push(.myWalkRecord)
            case .savedWalk:
                myPageCoordinator.push(.savedWalk)
            case .review:
                myPageCoordinator.push(.review)
            case .activityAreaSetting:
                myPageCoordinator.push(.activityAreaSetting)
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

