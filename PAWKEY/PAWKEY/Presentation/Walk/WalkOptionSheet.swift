//
//  WalkOptionSheet.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import SwiftUI

struct WalkOptionSheet: View {
    @State private var isExpandWalkingTime = false
    @State private var isExpandSafety = false
    @State private var isExpandConvenience = false
    @State private var isExpandEnvironment = false
    @State private var isExpandMood = false
    
    @State private var walkingTimeList: [CheckOption] = [
        .init(title: "20분 이내", isSelected: false),
        .init(title: "21~40분", isSelected: false),
        .init(title: "41~60분", isSelected: false),
        .init(title: "1시간 넘게", isSelected: false),
    ]

    @State private var safetyList: [CheckOption] = [
        .init(title: "킥보드/자전거 거의 없음", isSelected: false),
        .init(title: "차량 거의 없음", isSelected: false),
        .init(title: "야간에도 밝음", isSelected: false),
        .init(title: "보도/차도 구분됨", isSelected: false),
        .init(title: "넓은 보도", isSelected: false),
    ]

    @State private var convenienceList: [CheckOption] = [
        .init(title: "배변 봉투 쓰레기통", isSelected: false),
        .init(title: "벤치", isSelected: false),
        .init(title: "편의점", isSelected: false),
        .init(title: "반려견 동반 카페", isSelected: false),
    ]

    @State private var environmentList: [CheckOption] = [
        .init(title: "풀 많은 길 위주", isSelected: false),
        .init(title: "흙길 위주", isSelected: false),
        .init(title: "아스팔트/벽돌길 위주", isSelected: false),
        .init(title: "뛰어놀 공간", isSelected: false),
    ]

    @State private var moodList: [CheckOption] = [
        .init(title: "조용한 분위기", isSelected: false),
        .init(title: "적당한 유동인구", isSelected: false),
        .init(title: "유동 인구 많음", isSelected: false),
    ]

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer().frame(height: 28)
                Text("산책 경로 옵션")
                    .font(.head_20_b)
                    .padding(.leading, 16)
                Spacer().frame(height: 36)
                CheckBoxGroup(
                    isExpanded: $isExpandWalkingTime,
                    title: "🚶 산책 시간",
                    items: walkingTimeList
                ) { selectedOption in
                    
                }

                CheckBoxGroup(
                    isExpanded: $isExpandSafety,
                    title: "🚸 안전",
                    items: safetyList
                ) { selectedOption in
                    
                }

                CheckBoxGroup(
                    isExpanded: $isExpandConvenience,
                    title: "🧺 편리성 관련",
                    items: convenienceList
                ) { selectedOption in
                    
                }

                CheckBoxGroup(
                    isExpanded: $isExpandEnvironment,
                    title: "🌿 환경 관련",
                    items: environmentList
                ) { selectedOption in
                    
                }

                CheckBoxGroup(
                    isExpanded: $isExpandMood,
                    title: "😌 분위기",
                    items: moodList
                ) { selectedOption in
                    
                }

            }
        }
    }
}
