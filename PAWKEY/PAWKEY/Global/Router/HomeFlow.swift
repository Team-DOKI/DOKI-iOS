//
//  HomeFlow.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct HomeFlow: View {
    @EnvironmentObject var router: TabRouter<HomeScreen>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: HomeScreen.self) { screen in
                    build(screen: screen)
                }
        }
    }
    
    @ViewBuilder
    private func build(screen: HomeScreen) -> some View {
        switch screen {
        case .home:
            HomeView()
        case .changeMyArea:
            ChangeMyAreaView()
        }
    }
}
