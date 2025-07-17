//
//  ChangeMyAreaViewModel.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI
import Moya

struct UserAreaProfile {
    var region: String = ""
    var legalRegion: String = ""
}

enum AreaProfileField {
    case region(String)
    case legalRegion(String)
}

final class ChangeActivityAreaViewModel: ObservableObject {
    @Published var userProfile = UserAreaProfile()
    @Published var regions: [RegionUnit] = []
    
    @Published var selectedRegionId: Int?
    
    var guList: [String] {
        regions.map { $0.gu.name }
    }
    
    var dongList: [String] {
        guard let selectedGu = regions.first(where: { $0.gu.name == userProfile.region }) else { return [] }
        return selectedGu.dong.map { $0.name }
    }
    
    func changeUserInfo(_ field: AreaProfileField) {
        switch field {
        case .region(let region):
            userProfile.region = region
            userProfile.legalRegion = ""
            selectedRegionId = nil
            
        case .legalRegion(let legalRegion):
            userProfile.legalRegion = legalRegion
            selectedRegionId = findSelectedDongId()
        }
    }
    
    private func findSelectedDongId() -> Int? {
        guard let selectedGu = regions.first(where: { $0.gu.name == userProfile.region }) else {
            return nil
        }
        return selectedGu.dong.first(where: { $0.name == userProfile.legalRegion })?.id
    }
    
    @MainActor
    func fetchRegions() async {
        let provider = MoyaProvider<RegionAPI>()
        
        do {
            let response: BaseDTO<DistrictDTO> = try await provider.async.request(.fetchRegions)
            
            guard let data = response.data else {
                return
            }
            
            self.regions = data.districtDtos.toEntity()
            
            print(regions)
        } catch {
            print("Error fetching regions: \(error.localizedDescription)")
        }
    }
}
