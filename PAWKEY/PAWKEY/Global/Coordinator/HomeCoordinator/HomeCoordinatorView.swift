//
//  HomeCoordinatorView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @EnvironmentObject var coordinator: Coordinator<HomeScene>
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView()
                .navigationDestination(for: HomeScene.self) { scene in
                    scene.build()
                        .toolbar(.hidden)
                }
        }
    }
}
