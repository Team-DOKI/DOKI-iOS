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
    
    /// Presigned URL 요청
    func fetchPresignedURL(
        request: PresignedUrlRequest,
        completion: @escaping (NetworkResult<PresignedUrlResponseDTO>) -> Void
    ) {
        self.request(.presigned(request: request),
                     provider: provider,
                     responseType: PresignedUrlResponseDTO.self,
                     completion: completion)
    }
    
    /// 이미지 등록
    func registerImage(
        request: RegisterImageRequest,
        completion: @escaping (NetworkResult<RegisterImageResponseDTO>) -> Void
    ) {
        self.request(.register(request: request),
                     provider: provider,
                     responseType: RegisterImageResponseDTO.self,
                     completion: completion)
    }
}
