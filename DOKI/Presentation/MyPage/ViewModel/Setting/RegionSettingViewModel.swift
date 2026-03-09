//
//  RegionSettingViewModel.swift
//  DOKI
//
//  Created by 이세민 on 3/9/26.
//

import SwiftUI

class RegionSettingViewModel: ObservableObject {
    private let regionAPIService: RegionAPIServiceProtocol
    
    init(
        regionAPIService: RegionAPIServiceProtocol = RegionAPIService()
    ) {
        self.regionAPIService = regionAPIService
    }
    
    // MARK: - Published Properties
    
    @Published var regionList: [DistrictDTOs] = []
    @Published var selectedGuId: Int?
    @Published var selectedDongId: Int?
    @Published var previewRegionName: String = ""
    @Published var selectedRegionName: String = ""
    @Published var regionSearchText: String = ""
    @Published var regionFlow: RegionFlow = .none
    @Published var regionGeometry: Geometry? = nil
    @Published private(set) var originalRegionName: String = ""
    
    @Published var isSaveCompleted = false
    
    // MARK: - User Actions
    
    var isSaveButtonDisabled: Bool {
        return selectedRegionName == originalRegionName
    }
    
    func saveButtonTapped() {
        updateMyRegion()
    }
    
    func selectGuID(_ id: Int) {
        selectedGuId = id
        selectedDongId = nil
        previewRegionName = ""
        regionGeometry = nil
    }
    
    func selectDongId(_ id: Int) {
        selectedDongId = id
        guard let guId = selectedGuId,
              let region = regionList.first(where: { $0.gu.id == guId }),
              let dong = region.dongs.first(where: { $0.id == id }) else { return }
        
        selectedRegionName = "\(region.gu.name) \(dong.name)"
        previewRegionName = selectedRegionName
        
        fetchRegionGeometry()
        
        regionFlow = .map
    }
    
    func selectRegion() {
        selectedRegionName = previewRegionName
        regionFlow = .none
    }
    
    func resetRegionSelection() {
        previewRegionName = ""
        regionGeometry = nil
    }
}

// MARK: - API

extension RegionSettingViewModel {
    /// 지역구 조회
    func fetchRegions() {
        regionAPIService.fetchRegions { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.regionList = response?.data?.districtDtos ?? []
                    self.fetchMyRegion()
                default:
                    print("지역 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    /// 지역 폴리곤 좌표 조회
    func fetchRegionGeometry() {
        guard let dongId = selectedDongId else { return }
        
        regionAPIService.fetchRegionGeometry(regionId: dongId) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.regionGeometry = response?.data?.geometry
                default:
                    print("폴리곤 좌표 조회에 실패했습니다.")
                }
            }
        }
    }
    
    /// 내 현재 지역 조회
    func fetchMyRegion() {
        regionAPIService.fetchMyRegion { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    guard let myRegion = response?.data else { return }
                    
                    for region in self.regionList {
                        if let dong = region.dongs.first(where: { $0.id == myRegion.currentRegionId }) {
                            self.selectedGuId = region.gu.id
                            self.selectedDongId = dong.id
                            let fullName = "\(region.gu.name) \(dong.name)"
                            self.selectedRegionName = fullName
                            self.previewRegionName = fullName
                            self.originalRegionName = fullName
                            
                            self.fetchRegionGeometry()
                            break
                        }
                    }
                default:
                    print("내 지역 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
    
    func updateMyRegion() {
        guard let dongId = selectedDongId else {
            return
        }
        
        let request = UpdateMyRegionRequest(regionId: dongId)
        
        regionAPIService.updateMyRegion(request: request) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.originalRegionName = self.selectedRegionName
                    
                    DispatchQueue.main.async {
                        self.isSaveCompleted = true
                    }
                default:
                    print("내 지역 수정에 실패했습니다.")
                }
            }
        }
    }
}
