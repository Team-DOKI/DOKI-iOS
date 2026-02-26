//
//  DBTIAPIServiceProtocol.swift
//  DOKI
//
//  Created by 이세민 on 2/27/26.
//

import Foundation
import Moya

protocol DBTIAPIServiceProtocol {
    /// DBTI 질문 조회
    func fetchDBTIQuestions(
        completion: @escaping (NetworkResult<DBTIQuestionsResponseDTO>) -> Void
    )
}

extension DBTIAPIServiceProtocol {
    typealias DBTIQuestionsResponseDTO = BaseDTO<DBTIQuestionsResponse>
}

final class DBTIAPIService: BaseAPIService, DBTIAPIServiceProtocol {
    
    private let provider = MoyaProvider<DBTIAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    /// DBTI 질문 조회
    func fetchDBTIQuestions(
        completion: @escaping (NetworkResult<DBTIQuestionsResponseDTO>) -> Void
    ) {
        self.request(
            .fetchQuestions,
            provider: provider,
            responseType: DBTIQuestionsResponseDTO.self,
            completion: completion
        )
    }
}
