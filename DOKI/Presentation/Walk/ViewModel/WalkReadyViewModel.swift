//
//  WalkReadyViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkReadyViewModel: ObservableObject {
    private let coordinator: Coordinator<WalkRecordRoute>
    private let walkService: WalkAPIServiceProtocol
    
    init(coordinator: Coordinator<WalkRecordRoute>, walkService: WalkAPIServiceProtocol = WalkAPIService()) {
        self.coordinator = coordinator
        self.walkService = walkService
        
        fetchPreparationMessage()
    }
    
    @Published var mainMessage: String = ""
    @Published var subMessage: String = ""
    
    func navigateToWalkRecord() {
        coordinator.presentFullScreen(.walkRecord)
    }
}

extension WalkReadyViewModel {
    func fetchPreparationMessage() {
        walkService.fetchPreparationMessage { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.mainMessage = response?.data?.mainMessage ?? ""
                    self.subMessage = response?.data?.subMessage ?? ""
                    
                default:
                    print("산책 준비 메세지 조회 실패했습니다.")
                }
            }
        }
    }
}
