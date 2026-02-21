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
}

extension HomeAPIServiceProtocol {
    typealias WeatherResponseDTO = BaseDTO<WeatherResponse>
}

final class HomeAPIService: BaseAPIService, HomeAPIServiceProtocol {
    
    private let provider = MoyaProvider<HomeAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - 공통 request
    
    private func request<T: Decodable>(
        _ target: HomeAPI,
        completion: @escaping (NetworkResult<T>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }
            
            let networkResult: NetworkResult<T>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                } else {
                    networkResult = .networkFail
                }
            }
            
            completion(networkResult)
        }
    }
    
    // MARK: - API
    
    /// 날씨 조회
    func fetchWeather(
        completion: @escaping (NetworkResult<BaseDTO<WeatherResponse>>) -> Void
    ) {
        request(.fetchWeather, completion: completion)
    }
}
