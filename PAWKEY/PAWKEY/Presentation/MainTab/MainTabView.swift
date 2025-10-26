//
//  MainTabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {        
        TabView {
            HomeView()
                .tabItem {
                    Text("홈")
                }
            
            WalkView()
                .tabItem {
                    Text("산책")
                }
            
            RouteRecommendView()
                .tabItem {
                    Text("코스추천")
                }
        }
    }
}
