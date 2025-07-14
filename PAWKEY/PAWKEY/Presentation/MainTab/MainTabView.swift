//
//  MainTabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        @EnvironmentObject var tabBarState: MainTabViewModel
        
        ZStack {
            switch tabBarState.selectedTab {
            case .home:
                HomeCoordinatorView()
            case .walk:
                WalkCoordinatorView()
            case .community:
                CommunityView()
            case .mypage:
                MyPageCoordinatorView()
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
