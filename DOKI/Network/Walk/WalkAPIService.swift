//
//  WalkAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/18/26.
//

import Foundation
import Moya

protocol WalkAPIServiceProtocol {
    /// 산책 준비 메세지 조회
    func fetchPreparationMessage(completion: @escaping (NetworkResult<PreparationMessageResponseDTO>) -> Void)
}

extension WalkAPIServiceProtocol {
    typealias PreparationMessageResponseDTO = BaseDTO<PreparationMessageResponse>
}

final class WalkAPIService: BaseAPIService, WalkAPIServiceProtocol {
    
    private let provider = MoyaProvider<WalkAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - 공통 request
    
    private func request<T: Decodable>(
        _ target: WalkAPI,
        completion: @escaping (NetworkResult<T>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }
            
            let networkResult: NetworkResult<T>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                } else {
                    networkResult = .networkFail
                }
            }
            
            completion(networkResult)
        }
    }
    
    // MARK: - API
    
    /// 산책 준비 메세지 조회
    func fetchPreparationMessage(completion: @escaping (NetworkResult<PreparationMessageResponseDTO>) -> Void) {
        self.request(.preparationMessage, completion: completion)
    }
}
