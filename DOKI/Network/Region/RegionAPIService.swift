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
    func fetchRegions(completion: @escaping (NetworkResult<RegionsResponseDTO>) -> Void)
}

extension RegionAPIServiceProtocol {
    typealias RegionsResponseDTO = BaseDTO<RegionsResponse>
}

final class RegionAPIService: BaseAPIService, RegionAPIServiceProtocol {
    
    private let provider = MoyaProvider<RegionAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 지역구 조회
    func fetchRegions(completion: @escaping (NetworkResult<BaseDTO<RegionsResponse>>) -> Void) {
        request(.fetchRegions,
                provider: provider,
                responseType: BaseDTO<RegionsResponse>.self,
                completion: completion)
    }
}
