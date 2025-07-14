//
//  MainTabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var homeCoordinator = Coordinator<HomeScene>()
    @StateObject private var walkCoordinator = Coordinator<WalkScene>()
    @StateObject private var myPageCoordinator = Coordinator<MyPageScene>()
    
    @EnvironmentObject var tabBarState: TabBarState
    
    var body: some View {
        ZStack {
            switch tabBarState.selectedTab {
            case .home:
                HomeCoordinatorView()
                    .environmentObject(homeCoordinator)
            case .walk:
                WalkCoordinatorView()
                    .environmentObject(walkCoordinator)
            case .community:
                CommunityView()
            case .mypage:
                MyPageCoordinatorView()
                    .environmentObject(myPageCoordinator)
            }
            
            VStack {
                Spacer()
                
                TabBar()
                    .padding(.bottom, 12)
                    .offset(y: tabBarState.isHidden ? 100 : 0)
                    .animation(.easeInOut(duration: 0.3), value: tabBarState.isHidden)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
