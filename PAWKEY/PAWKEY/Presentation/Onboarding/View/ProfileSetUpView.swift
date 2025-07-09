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
            VStack {
                // 서브뷰
                Group {
                    switch viewModel.profileSetupStep {
                    case .ownerInfo:
                        UserInfoView()
                    case .activityArea:
                        ActivityAreaView()
                    case .dogInfo:
                        DogInfoView()
                    }
                }
                Spacer()
                CTAButton(title: "다음으로")
                    .padding(.bottom, 29)
            }
            .padding(.horizontal, 16)
        }
        .topNavigationView(center: {
            Text("회원가입")
                .font(.body_16_sb)
        })
    }
}
