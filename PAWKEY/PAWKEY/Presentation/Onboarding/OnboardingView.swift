//
//  OnboardingView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var router: Coordinator<OnboardingScreen>
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("안녕하세요.")
                Text("우리 강아지를 위한 산책,")
                HStack {
                    Text("PAWKEY")
                        .foregroundStyle(.green500)
                    Text("와 함께해요!")
                }
            }
            .font(.head_22_sb)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 50)
            
            Spacer()
            
            VStack(spacing: 20) {
                CTAButton(title: "신규계정으로 회원가입")
                CTAButton(title: "기존 계정으로 로그인", buttonStyle: .borderless) {                    
                    router.push(.login)
                }
            }
            .padding(.bottom, 47)
        }
        .padding(.horizontal, 16)
    }
}
