//
//  MyPageCoordinatorView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct MyPageCoordinatorView: View {
    @EnvironmentObject var coordinator: Coordinator<MyPageScene>
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MyPageView()
                .navigationDestination(for: MyPageScene.self) { scene in
                    scene.build()
                        .toolbar(.hidden)
                }
        }
    }
}
