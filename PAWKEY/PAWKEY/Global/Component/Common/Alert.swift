//
//  Alert.swift
//  PAWKEY
//
//  Created by 권석기 on 7/5/25.
//

import SwiftUI
import Lottie

struct Alert: View {
    var title: String
    var description: String
    var confirmButton: CTAButton
    
    var body: some View {
        VStack {
            LottieView(name: "review_check")
                .frame(width: 120, height: 120)
            
            Text(title)
                .font(.head_18_sb)
                .foregroundStyle(.pawkeyBlack)
                .padding(.bottom, 6)

            
            Text(description)
                .multilineTextAlignment(.center)
                .font(.caption_12_r)
                .foregroundStyle(.gray300)
                .padding(.bottom, 30)
            
            confirmButton
                .frame(height: 48)
        }
        .padding(.top, 36)
        .padding(.horizontal, 32)
        .padding(.bottom, 28)
        .background(.pawkeyWhite1)
        .cornerRadius(14)
    }
}

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: name)
        view.loopMode = loopMode
        view.play()
        return view
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
    }
}
