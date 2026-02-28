//
//  RouteAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import Foundation
import Moya

protocol RouteAPIServiceProtocol {
    /// 내가 작성한 게시글 조회
    func fetchMyPosts(
        completion: @escaping (NetworkResult<RouteCellResponseDTO>) -> Void
    )
    
    /// 내가 좋아요한 게시글 조회
    func fetchMyLikedPosts(
        completion: @escaping (NetworkResult<RouteCellResponseDTO>) -> Void
    )
}

extension RouteAPIServiceProtocol {
    typealias RouteCellResponseDTO = BaseDTO<RouteCellResponse>
}

final class RouteAPIService: BaseAPIService, RouteAPIServiceProtocol {
    
    private let provider = MoyaProvider<RouteAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    /// 내가 작성한 게시글 조회
    func fetchMyPosts(
        completion: @escaping (NetworkResult<RouteCellResponseDTO>) -> Void
    ) {
        self.request(
            .fetchMyPosts,
            provider: provider,
            responseType: RouteCellResponseDTO.self,
            completion: completion
        )
    }
    
    /// 내가 좋아요한 게시글 조회
    func fetchMyLikedPosts(
        completion: @escaping (NetworkResult<RouteCellResponseDTO>) -> Void
    ) {
        self.request(
            .fetchMyLikedPosts,
            provider: provider,
            responseType: RouteCellResponseDTO.self,
            completion: completion
        )
    }
}
