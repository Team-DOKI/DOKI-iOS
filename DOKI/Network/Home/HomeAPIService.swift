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
    /// 누적 산책 정보 조회
    func fetchTotalWalkStat(completion: @escaping (NetworkResult<TotalWalkStatResponseDTO>) -> Void)
}

extension HomeAPIServiceProtocol {
    typealias WeatherResponseDTO = BaseDTO<WeatherResponse>
    typealias TotalWalkStatResponseDTO = BaseDTO<TotalWalkStatResponse>
}

final class HomeAPIService: BaseAPIService, HomeAPIServiceProtocol {
    
    private let provider = MoyaProvider<HomeAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 날씨 조회
    func fetchWeather(completion: @escaping (NetworkResult<WeatherResponseDTO>) -> Void) {
        request(.fetchWeather,
                provider: provider,
                responseType: WeatherResponseDTO.self,
                completion: completion)
    }
    
    /// 누적 산책 정보 조회
    func fetchTotalWalkStat(completion: @escaping (NetworkResult<TotalWalkStatResponseDTO>) -> Void) {
        request(.fetchTotalWalkStat,
                provider: provider,
                responseType: TotalWalkStatResponseDTO.self,
                completion: completion)
    }
}
