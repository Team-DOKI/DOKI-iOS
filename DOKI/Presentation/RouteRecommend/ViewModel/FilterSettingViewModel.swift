//
//  FilterSettingViewModel.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

class FilterSettingViewModel: ObservableObject {
    @Published var walkTime: Int = 0
    @Published var congestion = "적음"
    @Published var dogInteraction = "교류 없음"
    @Published var safetyOption: [FilteringOption] = [
        FilteringOption(text: "차량 적음", isActive: false),
        FilteringOption(text: "보도/차도 분리", isActive: false),
        FilteringOption(text: "보도 넓음", isActive: false),
        FilteringOption(text: "킥보드/자전거 적음", isActive: false),
        FilteringOption(text: "야간 밝음", isActive: false)
    ]

    @Published var convenienceOption: [FilteringOption] = [
        FilteringOption(text: "벤치", isActive: false),
        FilteringOption(text: "배변 봉투 쓰레기통", isActive: false),
        FilteringOption(text: "편의점", isActive: false),
        FilteringOption(text: "반려견 동반 카페", isActive: false)
    ]

    @Published var environmentOption: [FilteringOption] = [
        FilteringOption(text: "잔디길", isActive: false),
        FilteringOption(text: "흙길", isActive: false),
        FilteringOption(text: "포장길", isActive: false),
        FilteringOption(text: "놀이터/공터", isActive: false)
    ]
    @Published var conditionOption = ["적음", "평범", "많음"]
    @Published var dogInteractionOption =  ["교류 없음", "보통", "교류 활발"]
}


