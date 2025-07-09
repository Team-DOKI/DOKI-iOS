//
//  DogTendencyView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct DogTendencyView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var energyLevel = ["매우 차분해요", "조금 느긋해요", "활동적이에요", "아주 활발해요"]
    var societyLevel = ["잘 어울려요", "천천히 친해져요", "낯을 가려요", "상관없어요"]
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                Spacer().frame(height: 20)
                
                Text("반려견 성향은 어떤가요?")
                    .font(.head_22_sb)
                    .foregroundStyle(.pawkeyBlack)
                
                Spacer().frame(height: 42)
                
                VStack(alignment:.leading) {
                    Text("에너지 레벨")
                        .font(.body_14_sb)
                    LazyVGrid(columns: columns) {
                        ForEach(energyLevel, id: \.self) {
                            ChoiceButton($0)
                        }
                    }
                }
                
                Spacer().frame(height: 30)
                
                VStack(alignment:.leading) {
                    Text("사회성 레벨")
                        .font(.body_14_sb)
                    LazyVGrid(columns: columns) {
                        ForEach(societyLevel, id: \.self) {
                            ChoiceButton($0)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    DogTendencyView()
}
