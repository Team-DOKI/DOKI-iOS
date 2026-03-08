//
//  FilterSettingViewModel.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

enum FilterSettingRoute {
    case back
    case saveOption(selectedOption: [FilterList])
}

final class FilterSettingViewModel: ObservableObject {
    // 산책 소요 값
    @Published var selectedCongestion: FilteringOption?
    
    // 교류 빈도 값
    @Published var selectedExchange: FilteringOption?
    
    // 산책 소요 시간
    @Published var duration: [FilteringOption] = []
    
    // 혼잡도
    @Published var congestion: [FilteringOption] = []
    
    // 강아지 교류 빈도
    @Published var exchange: [FilteringOption] = []
    
    // 안전
    @Published var safety: [FilteringOption] = []
    
    // 편의성
    @Published var convenience: [FilteringOption] = []
    
    // 환경
    @Published var environment: [FilteringOption] = []
    
    private let filterAPIServie: FilterAPIServiceProtocol
    
    // 선택된 필터 옵션
    var selectedFilterOptions: [FilterList] = []
    var navigationAction: ((FilterSettingRoute)->())?
    
    init(filterAPIService: FilterAPIService) {
        self.filterAPIServie = filterAPIService
    }
    
    // 뒤로가기
    func navigateToBack() {
        navigationAction?(.back)
    }
    
    /// 초기 옵션 설정
    /// - 서버 또는 RecommendView로 부터 전달받은 필터 카테고리 데이터를 적용
    func setFilterOption() {
        
        selectedFilterOptions.forEach {
            switch $0.filterType {
            case .duration:
                self.duration = $0.options
            case .congestion:
                self.congestion = $0.options
            case .exchange:
                self.exchange = $0.options
            case .safety:
                self.safety = $0.options
            case .convenience:
                self.convenience = $0.options
            case .environment:
                self.environment = $0.options
            case .unknown:
                print("존재하지 않는 필터 유형 입니다.")
            }
        }
    }
    
    /// 필터링 설정 완료 후 카테고리 데이터 전달
    /// 필터링된 값을 RecommendView로 전달
    func saveOption() {
        var selectedOption: [FilterList] = selectedFilterOptions

        for index in selectedOption.indices {
            switch selectedOption[index].filterType {
            case .duration:
                selectedOption[index].options = duration
            case .congestion:
                selectedOption[index].options = congestion
            case .exchange:
                selectedOption[index].options = exchange
            case .safety:
                selectedOption[index].options = safety
            case .convenience:
                selectedOption[index].options = convenience
            case .environment:
                selectedOption[index].options = environment
            case .unknown:
                break
            }
        }
        
        navigationAction?(.saveOption(selectedOption: selectedOption))
    }
}

// MARK: - API (필터링 카테고리 리스트 조회)

extension FilterSettingViewModel {
    @MainActor
    func fetchFilterCategories() async {
        if !selectedFilterOptions.isEmpty { return }
        
        do {
            let response = try await filterAPIServie.fetchFilterCategories()            
            selectedFilterOptions = response            
        } catch {
            print(error.localizedDescription)
        }
    }
}
