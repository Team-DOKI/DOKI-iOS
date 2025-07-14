//
//  OnboardingView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var coordinator: Coordinator<OnboardingScene>
    
    @State private var pawPrints: [PawPrint] = []
    
    var body: some View {
        ZStack {
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
                        coordinator.push(.login)
                    }
                }
                .padding(.bottom, 47)
            }
            
            ForEach(pawPrints) { print in
                Image(.walkIconFill)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .position(print.position)
                    .opacity(print.opacity)
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    addPawPrint(at: value.location)
                }
        )
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.5), value: pawPrints)
    }
    
    private func addPawPrint(at location: CGPoint) {
        let newPrint = PawPrint(position: location)
        pawPrints.append(newPrint)
        
        let id = newPrint.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if let index = pawPrints.firstIndex(where: { $0.id == id }) {
                pawPrints[index].opacity = 0.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            pawPrints.removeAll { $0.id == id }
        }
    }
}
