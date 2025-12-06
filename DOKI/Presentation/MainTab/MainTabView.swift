//
//  MainTabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appDIContainer: AppDIContainer
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeCoordinatorView(viewModelFactory: appDIContainer.viewModelFactory)
                    .tabItem {
                        Text("홈")
                    }
                
                WalkCoordinatorView(viewModelFactory: appDIContainer.viewModelFactory)
                    .tabItem {
                        Text("산책하기")
                    }
                
                RecommendCoordinatorView(viewModelFactory: appDIContainer.viewModelFactory)
                    .tabItem {
                        Text("루트 추천")
                    }
                MyPageCoordinatorView(viewModelFactory: appDIContainer.viewModelFactory)
                    .tabItem {
                        Text("마이페이지")
                    }
            }
        }
    }
}
