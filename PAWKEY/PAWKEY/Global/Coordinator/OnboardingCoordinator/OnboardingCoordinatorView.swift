//
//  OnboardingCoordinatorView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct OnboardingCoordinatorView: View {
    @EnvironmentObject var router: Coordinator<OnboardingScene>
    
    var body: some View {
        NavigationStack(path: $router.path) {
            OnboardingView()
                .navigationDestination(for: OnboardingScene.self) { scene in
                    scene.build()
                }
        }
    }
}
