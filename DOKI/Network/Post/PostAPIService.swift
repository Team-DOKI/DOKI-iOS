//
//  PostAPIService.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

import Moya

protocol PostAPIServiceProtocol {
    // 게시물 리스트 조회
    func fetchPosts() async throws -> (nextCursor: String, hasNext: Bool, posts: [PostItem])
}

extension PostAPIServiceProtocol {
    typealias PostResponseDTO = BaseDTO<PostResponse>
}

final class PostAPIService: BaseAPIService, PostAPIServiceProtocol {
    private let provider = MoyaProvider<PostAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    func fetchPosts() async throws -> (nextCursor: String, hasNext: Bool, posts: [PostItem]) {
        do {
            let response: PostResponseDTO = try await provider.async.request(.fetchPosts)
            guard let data = response.data else { throw APIError.decodingError }
            return (data.nextCursor, data.hasNext, data.posts.toEntities())
        } catch {
            throw error
        }
    }
}
