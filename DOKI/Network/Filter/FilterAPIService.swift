//
//  FilterAPIService.swift
//  DOKI
//
//  Created by 권석기 on 3/4/26.
//

import Moya

protocol FilterAPIServiceProtocol {
    // 필터링 카테고리 리스트 조회
    func fetchFilterCategories() async throws -> [FilterList]
}

extension FilterAPIServiceProtocol {
    typealias FilterCategoriesResponseDTO = BaseDTO<FilterCategoryResponse>
}

final class FilterAPIService: BaseAPIService, FilterAPIServiceProtocol {
    private let provider = MoyaProvider<FilterAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    func fetchFilterCategories() async throws -> [FilterList] {
        do {
            let response: FilterCategoriesResponseDTO = try await provider.async.request(.fetchFilterCategories)
            guard let data = response.data else {
                throw APIError.decodingError
            }
            return data.toEntities()
        } catch {
            throw error
        }
    }
}

enum APIError: Error {
    case decodingError
}
