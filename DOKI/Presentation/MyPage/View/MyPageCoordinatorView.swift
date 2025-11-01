//
//  MyPageCoordinatorView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum MyPageRoute: Route {
    
}

struct MyPageCoordinatorView: View {
    @StateObject var myPageCoordinator: Coordinator<MyPageRoute>
    @StateObject var myPageViewModel: MyPageViewModel
    
    init(myPageCoordinator: Coordinator<MyPageRoute> = Coordinator<MyPageRoute>(), viewModelFactory: AppDIContainer.ViewModelFactory) {
        self._myPageCoordinator = StateObject(wrappedValue: myPageCoordinator)
        self._myPageViewModel = StateObject(wrappedValue: viewModelFactory.makeMyPageViewModel())
    }
    var body: some View {
        NavigationStack(path: $myPageCoordinator.path) {
            MyPageView(viewModel: myPageViewModel)
        }
    }
}

//#Preview {
//    MyPageCoordinatorView()
//}
