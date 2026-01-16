//
//  MyPageCoordinatorView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum MyPageRoute: Route {
    case myProfile
    case petProfile
    case walkRecord
    case savedWalk
    case review
    case activityAreaSetting
    case appInfo
}

struct MyPageCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    
    @StateObject var myPageCoordinator: Coordinator<MyPageRoute>
    @StateObject var myPageViewModel: MyPageViewModel
    @StateObject var myProfileViewModel:  MyProfileViewModel
    @StateObject var petProfileViewModel:  PetProfileViewModel
    @StateObject var myWalkRecordViewModel: MyWalkRecordViewModel
    @StateObject var mySavedWalkViewModel: MySavedWalkViewModel
    
    init(myPageCoordinator: Coordinator<MyPageRoute> = Coordinator<MyPageRoute>(), viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._myPageCoordinator = StateObject(wrappedValue: myPageCoordinator)
        self._myPageViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPageViewModel())
        self._myProfileViewModel = StateObject(wrappedValue: viewModelFactory.makeMyProfileViewModel())
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
                        MyProfileView(viewModel: myProfileViewModel)
                    case .petProfile:
                        PetProfileView(viewModel: petProfileViewModel)
                    case .walkRecord:
                        MyWalkRecordView(viewModel: myWalkRecordViewModel)
                    case .savedWalk:
                        MySavedWalkView(viewModel: mySavedWalkViewModel)
                    case .review:
                        MyReviewView()
                    case .activityAreaSetting:
                        ActivityAreaSettingView()
                    case .appInfo:
                        AppInfoView()
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
            case .walkRecord:
                myPageCoordinator.push(.walkRecord)
            case .savedWalk:
                myPageCoordinator.push(.savedWalk)
            case .review:
                myPageCoordinator.push(.review)
            case .activityAreaSetting:
                myPageCoordinator.push(.activityAreaSetting)
            case .appInfo:
                myPageCoordinator.push(.appInfo)
            }
        }
    }
}
