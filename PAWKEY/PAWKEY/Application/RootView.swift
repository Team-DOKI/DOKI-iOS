//
//  RootView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    var body: some View {
        if mainTabViewModel.isLogin {
            MainTabView()                
        } else {
            OnboardingCoordinatorView()
        }
    }
}
