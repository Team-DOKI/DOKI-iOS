//
//  TabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct TabView: View {
    @State private var selectedTab: TabBarItem = .home
    
    @StateObject private var homeRouter = TabRouter<HomeScreen>()
    @StateObject private var walkRouter = TabRouter<WalkScreen>()
    @StateObject private var myPageRouter = TabRouter<MyPageScreen>()
    
    @StateObject private var tabBarState = TabBarState()
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeFlow()
                    .environmentObject(homeRouter)
                    .environmentObject(tabBarState)
            case .walk:
                WalkFlow()
                    .environmentObject(walkRouter)
                    .environmentObject(tabBarState)
            case .community:
                CommunityView()
            case .mypage:
                MyPageFlow()
                    .environmentObject(myPageRouter)
                    .environmentObject(tabBarState)
            }
            
            VStack {
                Spacer()
                
                TabBarView(selectedTab: $selectedTab)
                    .environmentObject(tabBarState)
            }
        }
    }
}
