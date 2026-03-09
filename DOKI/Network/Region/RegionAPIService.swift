//
//  RegionAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/22/26.
//

import Foundation
import Moya

protocol RegionAPIServiceProtocol {
    /// 지역구 조회
    func fetchRegions(completion: @escaping (NetworkResult<RegionListResponseDTO>) -> Void)
    
    /// 지역 폴리곤 좌표 조회
    func fetchRegionGeometry(regionId: Int, completion: @escaping (NetworkResult<RegionGeometryResponseDTO>) -> Void)
}

extension RegionAPIServiceProtocol {
    typealias RegionListResponseDTO = BaseDTO<RegionListResponse>
    typealias RegionGeometryResponseDTO = BaseDTO<RegionGeometryResponse>
}

final class RegionAPIService: BaseAPIService, RegionAPIServiceProtocol {
    
    private let provider = MoyaProvider<RegionAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 지역구 조회
    func fetchRegions(completion: @escaping (NetworkResult<RegionListResponseDTO>) -> Void) {
        request(.fetchRegions,
                provider: provider,
                responseType: RegionListResponseDTO.self,
                completion: completion)
    }
    
    /// 지역 폴리곤 좌표 조회
    func fetchRegionGeometry(regionId: Int, completion: @escaping (NetworkResult<RegionGeometryResponseDTO>) -> Void) {
        request(.fetchRegionGeometry(regionId: regionId),
                provider: provider,
                responseType: RegionGeometryResponseDTO.self,
                completion: completion)
    }
}
