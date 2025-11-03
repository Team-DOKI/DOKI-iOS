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
    @Published var safetyOption = ["차량 적음", "보도/차도 분리", "보도 넒음", "킥보드/자전거 적음", "야간 밝음"]
    @Published var convenienceOption = ["벤치", "배변 봉투 쓰레기통", "편의점", "반려견 동반 카페"]
    @Published var environmentOption = ["잔디길", "흙길", "포장길", "놀이터/공터"]
    @Published var conditionOption = ["적음", "평범", "많음"]
    @Published var dogInteractionOption =  ["교류 없음", "보통", "교류 활발"]    
}


