//
//  MyPageFlow.swift
//  PAWKEY
//
//  Created by 이세민 on 7/6/25.
//

import SwiftUI

struct MyPageFlow: View {
    @EnvironmentObject var router: TabRouter<MyPageScreen>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MyPageView()
                .navigationDestination(for: MyPageScreen.self) { screen in
                    build(screen: screen)
                        .toolbar(.hidden)
                }
        }
    }
    
    @ViewBuilder
    private func build(screen: MyPageScreen) -> some View {
        switch screen {
        case .myPage:
            MyPageView()
        case .userProfile:
            UserProfileView()
        case .petProfile:
            PetProfileView()
        }
    }
}
