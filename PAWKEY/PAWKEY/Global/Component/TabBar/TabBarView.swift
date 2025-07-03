//
//  TabBarView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: TabBarItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabBarItem.allCases, id: \.self) { item in
                Button(action: {
                    selectedTab = item
                }) {
                    ZStack {
                        if selectedTab == item {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 48, height: 48)
                        }
                        
                        (selectedTab == item ? item.selectedImage : item.normalImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedTab == item ? Color(red: 0.09, green: 0.74, blue: 0.18) : .white)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 6)
        .frame(width: 262, height: 60)
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))
        .cornerRadius(200)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .padding(.bottom, 12)
    }
}
