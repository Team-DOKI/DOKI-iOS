//
//  Alert.swift
//  PAWKEY
//
//  Created by 권석기 on 7/5/25.
//

import SwiftUI

struct Alert: View {
    var title: String
    var description: String
    var confirmButton: CTAButton
    
    var body: some View {
        VStack {
            Image(systemName: "pawprint.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundStyle(.green500)
                .padding(.bottom, 32)
            
            Text(title)
                .font(.head_18_sb)
                .foregroundStyle(.pawkeyBlack)
                .padding(.bottom, 6)
            
            Text(description)
                .multilineTextAlignment(.center)
                .font(.caption_12_r)
                .foregroundStyle(.gray300)
                .padding(.bottom, 32)
            
            confirmButton
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(height: 48)
        }
        .padding(.horizontal, 32)
        .padding(.top, 36)
        .padding(.bottom, 28)
        .background(Color.white)
        .cornerRadius(14)
    }
}
