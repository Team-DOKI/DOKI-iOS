//
//  WalkCoordinatorView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct WalkCoordinatorView: View {
    @EnvironmentObject var router: Coordinator<WalkScene>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MapAndListView()
                .navigationDestination(for: WalkScene.self) { scene in
                    scene.build()
                        .toolbar(.hidden)
                }
        }
    }
}
