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
            ProgessBarView()
            Spacer()
            
            // 서브뷰
            Group {
                switch viewModel.profileStep {
                case .ownerInfo:
                    UserInfoView()
                case .activityArea:
                    ActivityAreaView()
                case .dogInfo:
                    DogInfoView()
                case .dogTendency:
                    DogTendencyView()
                }
            }
            Spacer()
            CTAButton(title: "다음으로") {
                viewModel.goToNextStep()
            }
            .padding(.bottom, 29)
        }
        .topNavigationView(left: {
            VStack {
                if viewModel.profileStep.rawValue != 0 {
                    Text("뒤로가기")
                        .onTapGesture {
                            viewModel.goToPrevStep()
                        }
                }
            }
        }, center: {
            Text(viewModel.profileStep.navigationTitle)
                .font(.body_16_sb)
        })
    }
}

struct ProgessBarView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.gray100)
    }
}
