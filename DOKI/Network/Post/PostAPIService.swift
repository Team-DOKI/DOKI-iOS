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
    func uploadPost(isPublic: Bool, request: PostRegisterRequest)
    
}

extension PostAPIServiceProtocol {
    typealias PostResponseDTO = BaseDTO<PostResponse>
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
            
            return (data.nextCursor, data.hasNext, data.posts.toEntities())
        } catch {
            throw error
        }
    }
    
    func uploadPost(isPublic: Bool, request: PostRegisterRequest)  {
        
        self.request(.uploadPost(request: request),
                     provider: provider,
                     responseType: PostRegisterResponse.self,
                     completion: { result in
            switch result {
            case .success(let response):
                print("게시물 등록 성공: \(response)")
            default:
                break
            }
        })
    }
}


