//
//  FilterAPIService.swift
//  DOKI
//
//  Created by 권석기 on 3/4/26.
//

import Moya

protocol FilterAPIServiceProtocol {
    // 필터링 카테고리 리스트 조회
    func fetchFilterCategories() -> Void
}

final class FilterAPIService: BaseAPIService, FilterAPIServiceProtocol {
    private let provider = MoyaProvider<FilterAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    func fetchFilterCategories() {}
}
