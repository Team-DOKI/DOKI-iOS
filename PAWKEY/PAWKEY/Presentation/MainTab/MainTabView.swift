//
//  MainTabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    var body: some View {        
        ZStack {
            switch mainTabViewModel.selectedTab {
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
                    .offset(y: mainTabViewModel.isHidden ? 100 : 0)
                    .animation(.easeInOut(duration: 0.3), value: mainTabViewModel.isHidden)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
