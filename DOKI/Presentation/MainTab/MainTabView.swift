//
//  MainTabView.swift
//  DOKI
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appDIContainer: AppDIContainer
    @State private var selectedTab: TabBarItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                    
                case .walk:
                    WalkCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                    
                case .recommend:
                    RecommendCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                    
                case .mypage:
                    MyPageCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                }
            }
            
            .safeAreaInset(edge: .bottom) {
                TabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
        }
        .onAppear {
            print("ACCESS TOKEN: ", AuthManager.shared.accessToken ?? "nil")
        }
    }
}
