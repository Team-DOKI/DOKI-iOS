//
//  WalkPreparationViewModel.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

class WalkPreparationViewModel: ObservableObject {
    private let coordinator: Coordinator<WalkRecordRoute>
    private let walkAPIService: WalkAPIServiceProtocol
    
    init(coordinator: Coordinator<WalkRecordRoute>, walkAPIService: WalkAPIServiceProtocol = WalkAPIService()) {
        self.coordinator = coordinator
        self.walkAPIService = walkAPIService
        
        fetchPreparationMessage()
        fetchPreparation()
    }
    
    @Published var mainMessage: String = ""
    @Published var subMessage: String = ""
    
    @Published var preparationItems: [String] = []
    
    func navigateToWalkRecord() {
        coordinator.presentFullScreen(.walkRecord)
    }
}

//MARK: - API

extension WalkPreparationViewModel {
    /// 산책 준비 메세지 조회
    func fetchPreparationMessage() {
        walkAPIService.fetchPreparationMessage { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.mainMessage = response?.data?.mainMessage ?? ""
                    self.subMessage = response?.data?.subMessage ?? ""
                    
                default:
                    print("산책 준비 메세지 조회에 실패했습니다.")
                }
            }
        }
    }
    
    /// 산책 준비물 조회
    func fetchPreparation() {
        walkAPIService.fetchPreparation { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.preparationItems = response?.data?.preparation ?? []
                    
                default:
                    print("산책 준비물을 불러오지 못했습니다.")
                }
            }
        }
    }
    
    /// 산책 준비물 저장(동기화)
    func savePreparation() {
        let request = PreparationRequest(
            preparation: preparationItems
        )
        
        walkAPIService.savePreparation(request: request) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.preparationItems = response?.data?.preparation ?? []
                    
                default:
                    print("산책 준비물 저장에 실패했습니다.")
                }
            }
        }
    }
    
    /// 산책 시작
    func startWalk() {
        let request = WalkStartRequest(deviceInfo: "APPLE")
        
        walkAPIService.startWalk(request: request) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    WalkSessionManager.shared.routeId = response?.data?.routeId
                    
                    self.navigateToWalkRecord()
                    
                default:
                    print("산책 시작에 실패했습니다.")
                }
            }
        }
    }
}
