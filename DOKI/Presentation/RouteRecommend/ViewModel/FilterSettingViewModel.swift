//
//  FilterSettingViewModel.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

enum FilterSettingRoute {
    case back
    case saveOption(selectedOption: [FilteringOption])
}

class FilterSettingViewModel: ObservableObject {
    @Published var walkTime: Int = 0
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedDogInteraction: FilteringOption?
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
    
    @Published var congestionOption: [FilteringOption] = [
        FilteringOption(text: "적음", isActive: false),
        FilteringOption(text: "평범", isActive: false),
        FilteringOption(text: "많음", isActive: false)
    ]
    
    @Published var dogInteractionOption: [FilteringOption] = [
        FilteringOption(text: "교류 없음", isActive: false),
        FilteringOption(text: "보통", isActive: false),
        FilteringOption(text: "교류 활발", isActive: false)
    ]
    
    var navigationAction: ((FilterSettingRoute)->())?
    
    func navigateToBack() {
        navigationAction?(.back)
    }
    
    init() {
        setDefaultOption()
    }
    
    // 초기 옵션 설정
    func setDefaultOption() {
        selectedCongestion = congestionOption[0]
        selectedDogInteraction = dogInteractionOption[0]
    }
    
    func saveOption() {
        var selectedOption: [FilteringOption] = []
                
        selectedOption += safetyOption.filter { $0.isActive }
        selectedOption += convenienceOption.filter { $0.isActive }
        selectedOption += environmentOption.filter { $0.isActive }
        
        // 단일선택 옵션 추가
        if var selectedCongestion {
            selectedCongestion.isActive = true
            selectedOption.append(selectedCongestion)
        }
        if var selectedDogInteraction {
            selectedDogInteraction.isActive = true
            selectedOption.append(selectedDogInteraction)
        }
        
        if walkTime > 0 {
            selectedOption.append(FilteringOption(text: "\(walkTime)분 이상", isActive: true))
        }
        
        navigationAction?(.saveOption(selectedOption: selectedOption))
    }
}


