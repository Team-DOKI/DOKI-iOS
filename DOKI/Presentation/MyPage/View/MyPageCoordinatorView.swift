//
//  MyPageCoordinatorView.swift
//  PAWKEY
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
    @StateObject var myPageCoordinator: Coordinator<MyPageRoute>
    @StateObject var myPageViewModel: MyPageViewModel
    @StateObject var myProfileViewModel:  MyProfileViewModel
    
    init(myPageCoordinator: Coordinator<MyPageRoute> = Coordinator<MyPageRoute>(), viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._myPageCoordinator = StateObject(wrappedValue: myPageCoordinator)
        self._myPageViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPageViewModel())
        self._myProfileViewModel = StateObject(wrappedValue: viewModelFactory.makeMyProfileViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $myPageCoordinator.path) {
            MyPageView(viewModel: myPageViewModel)
                .navigationDestination(for: MyPageRoute.self) { destination in
                    switch destination {
                    case .myProfile:
                        MyProfileView(viewModel: myProfileViewModel)
                    case .petProfile:
                        PetProfileView()
                    case .walkRecord:
                        MyWalkRecordView()
                    case .savedWalk:
                        MySavedWalkView()
                    case .review:
                        MyReviewView()
                    case .activityAreaSetting:
                        ActivityAreaSettingView()
                    case .appInfo:
                        AppInfoView()
                    }
                }
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
