//
//  ImageAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

import Foundation
import Moya

protocol ImageAPIServiceProtocol {
    /// Presigned URL 요청
    func fetchPresignedURL(
        request: PresignedUrlRequest,
        completion: @escaping (NetworkResult<PresignedUrlResponseDTO>) -> Void
    )
    
    /// 이미지 등록
    func registerImage(
        request: RegisterImageRequest,
        completion: @escaping (NetworkResult<RegisterImageResponseDTO>) -> Void
    )
}

extension ImageAPIServiceProtocol {
    typealias PresignedUrlResponseDTO = BaseDTO<PresignedUrlResponse>
    typealias RegisterImageResponseDTO = BaseDTO<RegisterImageResponse>
}

final class ImageAPIService: BaseAPIService, ImageAPIServiceProtocol {
    
    private let provider = MoyaProvider<ImageAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - 공통 request
    
    private func request<T: Decodable>(
        _ target: ImageAPI,
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
    
    /// Presigned URL 요청
    func fetchPresignedURL(
        request: PresignedUrlRequest,
        completion: @escaping (NetworkResult<PresignedUrlResponseDTO>) -> Void
    ) {
        self.request(.presigned(request: request), completion: completion)
    }
    
    /// 이미지 등록
    func registerImage(
        request: RegisterImageRequest,
        completion: @escaping (NetworkResult<RegisterImageResponseDTO>) -> Void
    ) {
        self.request(.register(request: request), completion: completion)
    }
}
