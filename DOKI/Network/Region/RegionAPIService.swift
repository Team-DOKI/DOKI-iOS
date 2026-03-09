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
    
    /// 내 현재 지역 조회
    func fetchMyRegion(completion: @escaping (NetworkResult<MyRegionResponseDTO>) -> Void)
}

extension RegionAPIServiceProtocol {
    typealias RegionListResponseDTO = BaseDTO<RegionListResponse>
    typealias RegionGeometryResponseDTO = BaseDTO<RegionGeometryResponse>
    typealias MyRegionResponseDTO = BaseDTO<MyRegionResponse>
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
    
    /// 내 현재 지역 조회
    func fetchMyRegion(completion: @escaping (NetworkResult<MyRegionResponseDTO>) -> Void) {
        request(.fetchMyRegion,
                provider: provider,
                responseType: MyRegionResponseDTO.self,
                completion: completion)
    }
}
