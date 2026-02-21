//
//  DBTIStartView.swift
//  DOKI
//
//  Created by 이세민 on 2/21/26.
//


import SwiftUI

struct DBTIStartView: View {
    @ObservedObject var viewModel: DBTIViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("반려견 성향을 알아보는\nDBTI 성격 유형 검사")
                        .header2()
                        .multilineTextAlignment(.leading)
                    
                    Text("본 조사는 사용자 흥미를 위한 비공식 테스트입니다.")
                        .bodyDefault(color: .defaultMiddle)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 82)
            
            Image(.imgOnboardingdog)
            
            Spacer()
            
            if viewModel.entryContext == .afterRegister {
                Button {
                    viewModel.finish()
                } label: {
                    Text("건너뛰기")
                        .subtitle(color: .defaultMiddle)
                }
                .padding(.bottom, 8)
            }
            
            MainButton(
                text: "시작하기",
                buttonState: .active1
            ) {
                viewModel.navigationAction?(.dbtiSurvey)
            }
        }
        .padding(.horizontal, 16)
        .background(RadialGradient(
            gradient: Gradient(colors: [
                .onboardingGra1.opacity(0.3),
                .defaultBackground
            ]),
            center: .center,
            startRadius: 10,
            endRadius: 250
        ))
        .topNavigationView {
            BackButton {
                dismiss()
                
            }
        } center: {
            Text("DBTI 검사")
                .subtitle()
        }
    }
}
