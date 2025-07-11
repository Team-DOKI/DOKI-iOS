//
//  MainTabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var homeCoordinator = Coordinator<HomeScreen>()
    @StateObject private var walkCoordinator = Coordinator<WalkScreen>()
    @StateObject private var myPageCoordinator = Coordinator<MyPageScreen>()
    
    @EnvironmentObject var tabBarState: TabBarState
    
    var body: some View {
        ZStack {
            switch tabBarState.selectedTab {
            case .home:
                HomeCoordinator()
                    .environmentObject(homeCoordinator)
            case .walk:
                WalkCoordinator()
                    .environmentObject(walkCoordinator)
            case .community:
                CommunityView()
            case .mypage:
                MyPageCoordinator()
                    .environmentObject(myPageCoordinator)
            }
            
            VStack {
                Spacer()
                
                TabBar()
            }
        }
    }
}
