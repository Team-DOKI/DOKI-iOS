//
//  PostAPIService.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

import Moya
import SwiftUI

protocol PostAPIServiceProtocol {
    // 게시물 리스트 조회
    func fetchPosts(sortOption: SortOption, cursor: String, options: [FilterList]) async throws -> (nextCursor: String, hasNext: Bool, posts: [PostItem])
    func uploadPost(request: PostRegisterRequest) async throws -> PostResponseDTO
    func fetchPost(postId: Int) async throws -> PostDetailResponseDTO
}

extension PostAPIServiceProtocol {
    typealias PostResponseDTO = BaseDTO<PostResponse>
    typealias PostDetailResponseDTO = BaseDTO<PostDetailResponse>
}

final class PostAPIService: BaseAPIService, PostAPIServiceProtocol {
    private let provider = MoyaProvider<PostAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    func fetchPosts(sortOption: SortOption, cursor: String, options: [FilterList]) async throws -> (nextCursor: String, hasNext: Bool, posts: [PostItem]) {
        do {
            
            let response: PostResponseDTO = try await provider.async.request(
                .fetchPosts(
                    sortOption: sortOption,
                    cursor: cursor,
                    postRequestDto: options.toDto()
                )
            )
            
            guard let data = response.data else { throw APIError.decodingError }
            
            return (data.nextCursor ?? "", data.hasNext, data.posts.toEntities())
        } catch {
            throw error
        }
    }
    
    func uploadPost(request: PostRegisterRequest) async throws -> PostResponseDTO  {
        do {
            let response: PostResponseDTO = try await provider.async.request(.uploadPost(request: request))
            return response
        } catch {
            throw error
        }
    }
    
    func fetchPost(postId: Int) async throws -> PostDetailResponseDTO {
        do {
            let response: PostDetailResponseDTO = try await provider.async.request(.fetchPost(postId: postId))
            return response
        } catch {
            throw error
        }
    }
}


