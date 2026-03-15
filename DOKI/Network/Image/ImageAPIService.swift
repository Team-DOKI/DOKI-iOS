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
    
    func asyncPresignedURL(request: PresignedURLRequest) async throws -> PresignedURLResponseDTO
    func asyncRegisterImage(request: RegisterImageRequest) async throws -> RegisterImageResponseDTO
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
    
    func asyncPresignedURL(request: PresignedURLRequest) async throws -> PresignedURLResponseDTO {
        do {
            let response: PresignedURLResponseDTO = try await provider.async.request(.presignedURL(request: request))
            return response
        } catch {
            throw error
        }
    }
    
    func asyncRegisterImage(request: RegisterImageRequest) async throws -> RegisterImageResponseDTO {
        do {
            let response: RegisterImageResponseDTO = try await provider.async.request(.registerImage(request: request))
            return response
        } catch {
            throw error
        }
    }
}
