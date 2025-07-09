//
//  ProfileSetUpView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct ProfileSetUpView: View {
    @StateObject var viewModel: ProfileSetUpViewModel
    
    init(viewModel: ProfileSetUpViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            
        }
        .topNavigationView(center: {
            Text("회원가입")
                .font(.body_16_sb)
        })
    }
}
