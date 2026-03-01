//
//  KakaoLoginButton.swift
//  DOKI
//
//  Created by 권석기 on 9/21/25.
//

import SwiftUI

struct KakaoLoginButton: View {
    var isLoading: Bool = false
    let action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(.btnKakaologin)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(isLoading ? 0.6 : 1)
        }
        .disabled(isLoading)
    }
}

#Preview {
    KakaoLoginButton {}
}
