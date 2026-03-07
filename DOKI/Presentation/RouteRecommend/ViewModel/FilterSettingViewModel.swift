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
    @Published var walkTimeOption: [FilteringOption] = []
    
    // 안전
    @Published var safetyOption: [FilteringOption] = []
    
    // 편의성
    @Published var convenienceOption: [FilteringOption] = []
    
    // 환경
    @Published var environmentOption: [FilteringOption] = []
    
    // 혼잡도
    @Published var congestionOption: [FilteringOption] = []
    
    // 강아지 교류 빈도
    @Published var dogInteractionOption: [FilteringOption] = []
    
    private let isFetched: Bool
    
    private let filterAPIServie: FilterAPIServiceProtocol
    
    var navigationAction: ((FilterSettingRoute)->())?
    
    init(filterAPIService: FilterAPIService, isFetched: Bool = false) {
        self.filterAPIServie = filterAPIService
        self.isFetched = isFetched
    }
    
    // 뒤로가기
    func navigateToBack() {
        navigationAction?(.back)
    }
    
    // 초기 옵션 설정
    func setDefaultOption() {
        selectedCongestion = congestionOption[0]
        selectedDogInteraction = dogInteractionOption[0]
    }
    
    // 필터링 설정 완료 카테고리 데이터 전달
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
    @MainActor
    func fetchFilterCategories() async {
        guard isFetched == false else { return }
        
        do {
            let response = try await filterAPIServie.fetchFilterCategories()            
            
            response.forEach {
                switch $0.filterType {
                case .duration:
                    walkTimeOption = $0.options
                case .congestion:
                    congestionOption = $0.options
                case .exchange:
                    dogInteractionOption = $0.options
                case .safety:
                    safetyOption = $0.options
                case .convenience:
                    convenienceOption = $0.options
                case .environment:
                    environmentOption = $0.options
                case .unknown:
                    print("해당 필터의 FilterType이 없음")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
