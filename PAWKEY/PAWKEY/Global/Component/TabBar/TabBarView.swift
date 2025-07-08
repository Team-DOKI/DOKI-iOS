//
//  TabBarView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var tabBarState: TabBarState
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabBarItem.allCases, id: \.self) { item in
                Button(action: {
                    tabBarState.selectedTab = item
                }) {
                    ZStack {
                        if tabBarState.selectedTab == item {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 48, height: 48)
                        }
                        
                        (tabBarState.selectedTab == item ? item.selectedImage : item.normalImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 6)
        .frame(width: 262, height: 60)
        .background(.pawkeyBlack)
        .cornerRadius(200)
        .shadow(color: .pawkeyBlack.opacity(0.25), radius: 2, x: 0, y: 4)
        .padding(.bottom, 12)
        .offset(y: tabBarState.isHidden ? 100 : 0)
        .animation(.easeInOut(duration: 0.3), value: tabBarState.isHidden)
    }
}
