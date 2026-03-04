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
    @Published var selectedCongestion: FilteringOption?
    @Published var selectedDogInteraction: FilteringOption?
    
    // 산책 소요 시간
    @Published var walkTimeOption: [FilteringOption] = [
        FilteringOption(text: "시간 무관", isActive: false, category: "walkTime"),
        FilteringOption(text: "30분 미만", isActive: false, category: "walkTime"),
        FilteringOption(text: "30분~60분", isActive: false, category: "walkTime"),
        FilteringOption(text: "60분 이상", isActive: false, category: "walkTime")
    ]
    
    // 안전
    @Published var safetyOption: [FilteringOption] = [
        FilteringOption(text: "차량 적음", isActive: false, category: "safety"),
        FilteringOption(text: "보도/차도 분리", isActive: false, category: "safety"),
        FilteringOption(text: "보도 넓음", isActive: false, category: "safety"),
        FilteringOption(text: "킥보드/자전거 적음", isActive: false, category: "safety"),
        FilteringOption(text: "야간 밝음", isActive: false, category: "safety")
    ]
    
    // 편의성
    @Published var convenienceOption: [FilteringOption] = [
        FilteringOption(text: "벤치", isActive: false, category: "convenience"),
        FilteringOption(text: "배변 봉투 쓰레기통", isActive: false, category: "convenience"),
        FilteringOption(text: "편의점", isActive: false, category: "convenience"),
        FilteringOption(text: "반려견 동반 카페", isActive: false, category: "convenience")
    ]
    
    // 환경
    @Published var environmentOption: [FilteringOption] = [
        FilteringOption(text: "잔디길", isActive: false, category: "environment"),
        FilteringOption(text: "흙길", isActive: false, category: "environment"),
        FilteringOption(text: "포장길", isActive: false, category: "environment"),
        FilteringOption(text: "놀이터/공터", isActive: false, category: "environment")
    ]
    
    // 혼잡도
    @Published var congestionOption: [FilteringOption] = [
        FilteringOption(text: "적음", isActive: false, category: "congestion"),
        FilteringOption(text: "평범", isActive: false, category: "congestion"),
        FilteringOption(text: "많음", isActive: false, category: "congestion")
    ]
    
    // 강아지 교류 빈도
    @Published var dogInteractionOption: [FilteringOption] = [
        FilteringOption(text: "교류 없음", isActive: false, category: "dogInteraction"),
        FilteringOption(text: "보통", isActive: false, category: "dogInteraction"),
        FilteringOption(text: "교류 활발", isActive: false, category: "dogInteraction")
    ]
    
    private let filterAPIServie: FilterAPIServiceProtocol
    
    var navigationAction: ((FilterSettingRoute)->())?
    
    func navigateToBack() {
        navigationAction?(.back)
    }
    
    init(filterAPIService: FilterAPIService) {
        self.filterAPIServie = filterAPIService
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
        
        // 단일 선택 옵션 추가
        if var selectedCongestion {
            selectedCongestion.isActive = true
            selectedOption.append(selectedCongestion)
        }
        if var selectedDogInteraction {
            selectedDogInteraction.isActive = true
            selectedOption.append(selectedDogInteraction)
        }
        
        if let selectedWalkTime = walkTimeOption.first(where: { $0.isActive }) {
            selectedOption.append(selectedWalkTime)
        }
        
        navigationAction?(.saveOption(selectedOption: selectedOption))
    }
}

// MARK: - API (필터링 카테고리 리스트 조회)

extension FilterSettingViewModel {
    func fetchFilterCategories() async {
        do {
            try await filterAPIServie.fetchFilterCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
}
