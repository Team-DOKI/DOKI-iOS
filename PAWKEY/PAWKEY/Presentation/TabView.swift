//
//  TabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct TabView: View {
    @State private var selectedTab: TabBarItem = .home
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    Color.white.ignoresSafeArea().overlay(Text("홈").font(.largeTitle))
                case .walk:
                    Color.white.ignoresSafeArea().overlay(Text("산책하기").font(.largeTitle))
                case .community:
                    Color.white.ignoresSafeArea().overlay(Text("커뮤니티").font(.largeTitle))
                case .mypage:
                    Color.white.ignoresSafeArea().overlay(Text("마이페이지").font(.largeTitle))
                }
            }
            
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}
