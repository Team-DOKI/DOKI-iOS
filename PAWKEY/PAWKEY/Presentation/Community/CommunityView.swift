//
//  CommunityView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(.imgCommunity)
            
            Text("커뮤니티 기능은\n아직 준비중이에요")
                .font(.body_16_sb)
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray300)
        }
    }
}
