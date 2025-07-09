//
//  ActivityAreaView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct ActivityAreaView: View {
    
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                
                Spacer().frame(height: 20)
                
                Text("활동 범위가 어떻게 되시나요?")
                    .font(.head_22_sb)
                    .foregroundStyle(.pawkeyBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 42)
                
                VStack(alignment: .leading) {
                    Text("지역구")
                        .font(.body_14_sb)
                    FlexibleGridView(availableWidth: proxy.size.width - 32,
                                     data: ["강남구"],
                                     spacing: 14,
                                     alignment: .leading, content: {
                        ChoiceButton($0, type: .small)
                    })
                    .clipped()
                }
                
                Spacer().frame(height: 42)
                
                VStack(alignment: .leading) {
                    Text("법정동")
                        .font(.body_14_sb)
                    FlexibleGridView(availableWidth: proxy.size.width - 32,
                                     data: ["개포동", "논현동", "대치동", "도곡동", "삼성동", "세곡동", "수서동", "신사동", "압구정동", "역삼동", "율현동", "자곡동", "청담동", "일원동"],
                                     spacing: 14,
                                     alignment: .leading, content: {
                        ChoiceButton($0, type: .small)
                    })
                    .padding(.trailing, 72)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ActivityAreaView()
}
