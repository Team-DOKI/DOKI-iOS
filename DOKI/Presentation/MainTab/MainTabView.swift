//
//  MainTabView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/2/25.
//

import SwiftUI

enum MainTab: Int, CaseIterable {
    case home
    case walk
    case recommend
    case mypage
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .walk: return "산책하기"
        case .recommend: return "루트 추천"
        case .mypage: return "마이페이지"
        }
    }
    
    var normalImage: String {
        switch self {
        case .home: return "ic_home"
        case .walk: return "ic_walk"
        case .recommend: return "ic_route"
        case .mypage: return "ic_profile"
        }
    }
    
    var selectedImage: String {
        switch self {
        case .home: return "ic_home_fill"
        case .walk: return "ic_walk_fill"
        case .recommend: return "ic_route_fill"
        case .mypage: return "ic_profile_fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appDIContainer: AppDIContainer
    @State private var selectedTab: MainTab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                    
                case .walk:
                    WalkCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                    
                case .recommend:
                    RecommendCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                    
                case .mypage:
                    MyPageCoordinatorView(
                        viewModelFactory: appDIContainer.viewModelFactory
                    )
                }
            }
            
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}


struct CustomTabBar: View {
    @Binding var selectedTab: MainTab
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 35) {
                ForEach(MainTab.allCases, id: \.self) { tab in
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
