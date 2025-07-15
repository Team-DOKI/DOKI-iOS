//
//  StopConfirmationView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import SwiftUI

struct StopConfirmationView: View {
    let description: String
    let onResume: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("산책이 중단되었어요.")
                .font(.head_24_b)
                .foregroundColor(.pawkeyWhite1)
                .padding(.bottom, 12)
            
            Text(description)
                .font(.body_16_m)
                .foregroundColor(.pawkeyWhite2)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: onResume) {
                    Text("계속 산책하기")
                        .font(.body_16_sb)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.pawkeyWhite1)
                        .foregroundColor(.green500)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green500, lineWidth: 1)
                        )
                        .cornerRadius(8)
                }
                
                CTAButton(
                    title: "산책 기록 중지",
                    isDisabled: false,
                    buttonStyle: .filled,
                    action: onStop
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 26)
        }
    }
}
