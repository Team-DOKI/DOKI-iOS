//
//  OnboardingView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var coordinator: Coordinator<OnboardingScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @State private var selection = 0
    @State private var pawPrints: [PawPrint] = []
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding1",
            title: "우리 강아지를 위한 산책,\nPAWKEY와 함께해요!",
            subtitle: " "
        ),
        OnboardingPage(
            imageName: "onboarding2",
            title: "새로운 산책의 시작!",
            subtitle: "최적화된 산책 환경에서 더 즐겁고 의미있는 산책을\n우리 강아지와 함께 시작해보세요."
        ),
        OnboardingPage(
            imageName: "onboarding3",
            title: "매일매일 새로운 루트로!\n우리 강아지와 나만의 산책.",
            subtitle: " "
        ),
        OnboardingPage(
            imageName: "onboarding4",
            title: "산책을 기록하고 공유하고\n수집해보세요.",
            subtitle: " "
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.green500
                .ignoresSafeArea(edges: .bottom)
            
            VStack {
                VStack {
                    ZStack(alignment: .topLeading) {
                        TabView(selection: $selection) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Image(pages[index].imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .tag(index)
                            }
                            .padding(.bottom, 30)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            let title = pages[selection].title
                                let keyword = "PAWKEY"
                                
                                if title.contains(keyword) {
                                    let parts = title.components(separatedBy: keyword)
                                    
                                    (
                                        Text(parts.first ?? "")
                                            .foregroundStyle(.pawkeyBlack) +
                                        Text(keyword)
                                            .foregroundColor(.green500) +
                                        Text(parts.count > 1 ? parts[1] : "")
                                            .foregroundColor(.pawkeyBlack)
                                    )
                                    .font(.head_24_b)
                                } else {
                                    Text(title)
                                        .font(.head_24_b)
                                        .foregroundColor(.primary)
                                }
                            
                            Text(pages[selection].subtitle)
                                .font(.body_16_m)
                                .foregroundColor(.gray400)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 42)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            // TODO: 개발시에만 사용(삭제 예정)
                            mainTabViewModel.isLogin = true
                        }
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { i in
                            Capsule()
                                .fill(i == selection ? Color.green500 : Color.green200)
                                .frame(width: i == selection ? 24 : 12, height: 12)
                                .animation(.easeInOut(duration: 0.2), value: selection)
                        }
                    }
                    .padding(.bottom, 20)
                    
                }
                .background(Color.white)
                .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                
                VStack(spacing: 20) {
                    Button(action: {
                    }) {
                        Text("신규계정으로 회원가입")
                            .font(.body_16_sb)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pawkeyWhite1)
                            .foregroundColor(Color.green500)
                            .cornerRadius(8)
                    }
                    CTAButton(title: "기존 계정으로 로그인", buttonStyle: .filled) {
                        coordinator.push(.login)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 36)
                .padding(.bottom, 14)
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
        //        .gesture(
        //            DragGesture(minimumDistance: 0)
        //                .onEnded { value in
        //                    addPawPrint(at: value.location)
        //                }
        //        )
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
