//
//  OnboardingView.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import SwiftUI

enum OnboardingStep: CaseIterable {
    case welcome
    case record
    case share
    case explore
    
    var title: String {
        switch self {
        case .welcome:
            "우리 강아지를 위한 산책"
        case .record:
            "산책을 경험에 맞춰 기록하세요"
        case .share:
            "기록한 산책길을 이웃과 나누세요"
        case .explore:
            "공유된 산책길을 따라 걸어보세요"
        }
    }
    
    var subTitle: String {
        switch self {
        case .welcome:
            "DOKI와 즐거운 산책을 시작해봐요!\n"
        case .record:
            "산책의 거리, 분위기, 활동 등을 카테고리에 따라\n특별한 일상으로 저장할 수 있어요"
        case .share:
            "내가 걸었던 루트를 공유하고\n다른 보호자들과 함께 즐길 수 있어요"
        case .explore:
            "이웃들이 남긴 루트를 걸으며\n해당 루트에 대한 유용한 정보를 얻을 수 있어요"
        }
    }
}

struct OnboardingView: View {
    @State private var currentStep: OnboardingStep = .welcome
    @Binding var isOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.imgLogo)
                .padding(.top, 40)
            
            Text(currentStep.title)
                .font(.header2)
                .foregroundStyle(.contents)
                .padding(.top, 40)
            
            Text(currentStep.subTitle)
                .font(.bodyDefault)
                .foregroundStyle(.defaultDark)
                .padding(.top, 8)
                .multilineTextAlignment(.center)
            
            TabView(selection: $currentStep) {
                Image(.imgOnboardingdog)
                
                    .tag(OnboardingStep.welcome)
                
                Image(.onboardingDummy)
                    .tag(OnboardingStep.record)
                
                Image(.onboardingDummy)
                    .tag(OnboardingStep.share)
                
                Image(.onboardingDummy)
                    .tag(OnboardingStep.explore)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack(spacing: 4) {
                ForEach(OnboardingStep.allCases, id: \.self) { step in
                    Rectangle()
                        .frame(width: currentStep == step ? 16 : 8, height: 8)
                        .cornerRadius(8)
                        .foregroundStyle(currentStep == step ? .defaultPrimary : .defaultButton)
                        .animation(.default, value: currentStep)
                }
            }
            .padding(.bottom, 24)
            
            Button {
                
            } label: {
                Text("건너뛰기")
                    .font(.small)
                    .foregroundColor(.defaultMiddle)
            }.padding(.bottom, 14)
            
            MainButton(text: "시작하기") {
                isOnboarding = true
            }
        }
        .padding(.horizontal, 16)
        .background(onboardingBackground)
    }
    
    private var onboardingBackground: some View {
        AnyView(
            Group {
                if currentStep == .welcome {
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .onboardingGra1.opacity(0.3),
                            .defaultBackground
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 250
                    )
                } else {
                    Color.defaultBackground
                }
            }
        )
    }
}
