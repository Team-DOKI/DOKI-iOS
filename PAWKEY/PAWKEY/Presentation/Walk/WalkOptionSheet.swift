//
//  WalkOptionSheet.swift
//  PAWKEY
//
//  Created by 권석기 on 7/11/25.
//

import SwiftUI

struct WalkOptionSheet: View {
    @ObservedObject var viewModel: CourseListViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 28)
                    Text("산책 경로 옵션")
                        .font(.head_20_b)
                        .padding(.leading, 16)
                    Spacer().frame(height: 36)
                    Text("복수 선택 옵션")
                        .font(.caption_12_sb)
                        .foregroundStyle(.green500)
                        .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                        .padding(.leading, 16)
                    CheckBoxGroup(
                        isExpanded: $viewModel.isExpandWalkingTime,
                        title: "🚶 산책 시간",
                        items: viewModel.walkingTimeList
                    ) { itemIndex in
                        viewModel.selectWalkRouteOption(.walkingTime(index: itemIndex))
                    }
                    CheckBoxGroup(
                        isExpanded: $viewModel.isExpandSafety,
                        title: "🚸 안전",
                        items: viewModel.safetyList
                    ) { itemIndex in
                        viewModel.selectWalkRouteOption(.safety(index: itemIndex))
                    }
                    
                    CheckBoxGroup(
                        isExpanded: $viewModel.isExpandConvenience,
                        title: "🧺 편리성 관련",
                        items: viewModel.convenienceList
                    ) { itemIndex in
                        viewModel.selectWalkRouteOption(.convenience(index: itemIndex))
                    }
                    
                    Spacer().frame(height: 36)
                    Text("단일 선택 옵션")
                        .font(.caption_12_sb)
                        .foregroundStyle(.green500)
                        .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                        .padding(.leading, 16)
                    
                    RadioGroup(
                        isExpanded: $viewModel.isExpandEnvironment,
                        title: "🌿 환경 관련",
                        items: viewModel.environmentList
                    ) { itemIndex in
                        viewModel.selectWalkRouteOption(.environment(index: itemIndex))
                    }
                    
                    RadioGroup(
                        isExpanded: $viewModel.isExpandMood,
                        title: "😌 분위기",
                        items: viewModel.moodList
                    ) { itemIndex in
                        viewModel.selectWalkRouteOption(.mood(index: itemIndex))
                    }
                }
            }
            HStack {
                CTAButton(title: "옵션 적용하기")
                Button {
                    viewModel.resetAllOptions()
                } label: {
                    VStack {
                        Image(.rotateIcon)
                    }
                    .frame(maxWidth: 56, minHeight: 56)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray50)
                )
            }
            .padding(.horizontal, 16)
        }
    }
}
