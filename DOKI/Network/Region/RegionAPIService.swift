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
}

extension RegionAPIServiceProtocol {
    typealias RegionListResponseDTO = BaseDTO<RegionListResponse>
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
}
