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
    func presignedURL(
        request: PresignedURLRequest,
        completion: @escaping (NetworkResult<PresignedURLResponseDTO>) -> Void
    )
    
    /// 이미지 등록
    func registerImage(
        request: RegisterImageRequest,
        completion: @escaping (NetworkResult<RegisterImageResponseDTO>) -> Void
    )
}

extension ImageAPIServiceProtocol {
    typealias PresignedURLResponseDTO = BaseDTO<PresignedURLResponse>
    typealias RegisterImageResponseDTO = BaseDTO<RegisterImageResponse>
}

final class ImageAPIService: BaseAPIService, ImageAPIServiceProtocol {
    
    private let provider = MoyaProvider<ImageAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// Presigned URL 요청
    func presignedURL(
        request: PresignedURLRequest,
        completion: @escaping (NetworkResult<PresignedURLResponseDTO>) -> Void
    ) {
        self.request(.presignedURL(request: request),
                     provider: provider,
                     responseType: PresignedURLResponseDTO.self,
                     completion: completion)
    }
    
    /// 이미지 등록
    func registerImage(
        request: RegisterImageRequest,
        completion: @escaping (NetworkResult<RegisterImageResponseDTO>) -> Void
    ) {
        self.request(.registerImage(request: request),
                     provider: provider,
                     responseType: RegisterImageResponseDTO.self,
                     completion: completion)
    }
}
