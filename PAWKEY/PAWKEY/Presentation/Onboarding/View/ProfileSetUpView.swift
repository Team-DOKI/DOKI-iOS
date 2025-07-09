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
        GeometryReader { proxy in
            VStack {
                ProgessBarView(
                    width: proxy.size.width,
                    step:viewModel.step
                )
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
}

struct ProgessBarView: View {
    let width: CGFloat
    let step: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.gray100)
            Rectangle()
                .frame(width: width * Double(step) / 4, height: 2)
                .foregroundStyle(.green500)
        }
        .animation(.easeInOut, value: step)
    }
}
