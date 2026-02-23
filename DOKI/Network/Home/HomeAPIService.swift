//
//  HomeAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

import Foundation
import Moya

protocol HomeAPIServiceProtocol {
    /// 날씨 조회
    func fetchWeather(completion: @escaping (NetworkResult<WeatherResponseDTO>) -> Void)
    /// 산책 정보(누적) 조회
    func fetchWalkInfo(completion: @escaping (NetworkResult<WalkInfoResponseDTO>) -> Void)
}

extension HomeAPIServiceProtocol {
    typealias WeatherResponseDTO = BaseDTO<WeatherResponse>
    typealias WalkInfoResponseDTO = BaseDTO<WalkInfoResponse>
}

final class HomeAPIService: BaseAPIService, HomeAPIServiceProtocol {
    
    private let provider = MoyaProvider<HomeAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 날씨 조회
    func fetchWeather(completion: @escaping (NetworkResult<BaseDTO<WeatherResponse>>) -> Void) {
        request(.fetchWeather,
                provider: provider,
                responseType: BaseDTO<WeatherResponse>.self,
                completion: completion)
    }
    
    /// 산책 정보(누적) 조회
    func fetchWalkInfo(completion: @escaping (NetworkResult<BaseDTO<WalkInfoResponse>>) -> Void) {
        request(.fetchWalkInfo,
                provider: provider,
                responseType: BaseDTO<WalkInfoResponse>.self,
                completion: completion)
    }
}
