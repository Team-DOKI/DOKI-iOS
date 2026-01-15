//
//  TabBar.swift
//  DOKI
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: TabBarItem
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 35) {
                ForEach(TabBarItem.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(
                                selectedTab == tab
                                ? tab.selectedImage
                                : tab.normalImage
                            )
                            
                            Text(tab.title)
                                .font(.small)
                                .foregroundStyle(
                                    selectedTab == tab ? .defaultPrimary : .defaultMiddle
                                )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 8)
        }
        .background(
            Color.white
                .clipShape(
                    RoundedCorner(
                        radius: 24,
                        corners: [.topLeft, .topRight]
                    )
                )
                .shadow(color: .contents.opacity(0.15), radius: 3.5, x: 0, y: -1)
                .ignoresSafeArea(edges: .bottom)
        )
        .ignoresSafeArea(edges: .bottom)
        .ignoresSafeArea(.keyboard)
    }
}
