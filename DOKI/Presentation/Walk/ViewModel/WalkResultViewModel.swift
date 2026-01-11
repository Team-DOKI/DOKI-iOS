//
//  WalkResultViewModel.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

enum WalkResultRoute {
    case backToRoot
}

class WalkResultViewModel: ObservableObject {
    var navigationAction: ((WalkResultRoute)->())?
    @Published var reviewTitle: String = ""
    @Published var reviewContent: String = ""
    @Published var address: String = "상세 주소"
    @Published var recordDate: String = "YY.MM.DD | 오후 00:00"
    @Published var walkRecord: String = "거리 | 시간 | 걸음수"
    @Published var reviewImages: [UIImage] = []
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
    
    func navigateBackToRoot() {
        navigationAction?(.backToRoot)
    }
}
