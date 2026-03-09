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
    
    @Published var regionList: [DistrictDTOs] = []
    @Published var selectedGuId: Int?
    @Published var selectedDongId: Int?
    @Published var selectedRegionName: String = ""
    @Published var areaSearchText: String = ""
    @Published var regionFlow: RegisterViewModel.RegionFlow = .none
    @Published var regionGeometry: Geometry? = nil
    
    func selectGuID(_ id: Int) {
        selectedGuId = id
        selectedDongId = nil
    }
    
    func seletDongId(_ id: Int) {
        selectedDongId = id
        if let guId = selectedGuId,
           let region = regionList.first(where: { $0.gu.id == guId }),
           let dong = region.dongs.first(where: { $0.id == id }) {
            selectedRegionName = "\(region.gu.name) \(dong.name)"
        }
    }
}

extension RegionSettingViewModel {
    /// 지역구 조회
    func fetchRegions() {
        regionAPIService.fetchRegions { [weak self] result in
            guard let self else { return }
            
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
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let geometry = response?.data?.geometry {
                        self.regionGeometry = geometry
                    }
                default:
                    print("폴리곤 좌표 조회에 실패했습니다.")
                }
            }
        }
    }
    
    /// 내 현재 지역 조회
    func fetchMyRegion() {
        regionAPIService.fetchMyRegion { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let myRegion = response?.data {
                        for region in self.regionList {
                            if let dong = region.dongs.first(where: { $0.id == myRegion.currentRegionId }) {
                                self.selectedGuId = region.gu.id
                                self.selectedDongId = dong.id
                                self.selectedRegionName = "\(region.gu.name) \(dong.name)"
                                break
                            }
                        }
                    }
                default:
                    print("내 지역 정보를 불러오지 못했습니다.")
                }
            }
        }
    }
}
