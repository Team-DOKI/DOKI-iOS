//
//  TabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct TabView: View {
    @StateObject private var homeRouter = TabRouter<HomeScreen>()
    @StateObject private var walkRouter = TabRouter<WalkScreen>()
    @StateObject private var myPageRouter = TabRouter<MyPageScreen>()
    
    @EnvironmentObject var tabBarState: TabBarState
    
    var body: some View {
        ZStack {
            switch tabBarState.selectedTab {
            case .home:
                HomeFlow()
                    .environmentObject(homeRouter)
            case .walk:
                WalkFlow()
                    .environmentObject(walkRouter)
            case .community:
                CommunityView()
            case .mypage:
                MyPageFlow()
                    .environmentObject(myPageRouter)
            }
            
            VStack {
                Spacer()
                
                TabBarView()
            }
        }
    }
}
