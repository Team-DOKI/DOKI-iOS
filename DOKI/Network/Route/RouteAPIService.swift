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
        completion: @escaping (NetworkResult<RouteInfoResponseDTO>) -> Void
    )
    
    /// 내가 좋아요한 게시글 조회
    func fetchMyLikedPosts(
        completion: @escaping (NetworkResult<RouteInfoResponseDTO>) -> Void
    )
    
    /// 게시글 좋아요/취소
    func toggleLike(
        postId: Int,
        completion: @escaping (NetworkResult<LikeResponseDTO>) -> Void
    )
}

extension RouteAPIServiceProtocol {
    typealias RouteInfoResponseDTO = BaseDTO<RouteInfoResponse>
    typealias LikeResponseDTO = BaseDTO<LikeResponse>
}

final class RouteAPIService: BaseAPIService, RouteAPIServiceProtocol {
    
    private let provider = MoyaProvider<RouteAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 내가 작성한 게시글 조회
    func fetchMyPosts(
        completion: @escaping (NetworkResult<RouteInfoResponseDTO>) -> Void
    ) {
        self.request(
            .fetchMyPosts,
            provider: provider,
            responseType: RouteInfoResponseDTO.self,
            completion: completion
        )
    }
    
    /// 내가 좋아요한 게시글 조회
    func fetchMyLikedPosts(
        completion: @escaping (NetworkResult<RouteInfoResponseDTO>) -> Void
    ) {
        self.request(
            .fetchMyLikedPosts,
            provider: provider,
            responseType: RouteInfoResponseDTO.self,
            completion: completion
        )
    }
    
    /// 게시글 좋아요/취소
    func toggleLike(postId: Int, completion: @escaping (NetworkResult<LikeResponseDTO>) -> Void) {
        self.request(
            .toggleLike(postId: postId),
            provider: provider,
            responseType: LikeResponseDTO.self,
            completion: completion
        )
    }
}
