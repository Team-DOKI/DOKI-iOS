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
    
    /// DBTI 검사 제출
    func submitDBTI(
        petId: Int,
        request: DBTISurveyRequest,
        completion: @escaping (NetworkResult<DBTIResultResponseDTO>) -> Void
    )
    
    /// DBTI 결과 조회
    func fetchDBTIResult(
        petId: Int,
        completion: @escaping (NetworkResult<DBTIResultResponseDTO>) -> Void
    )
}

extension DBTIAPIServiceProtocol {
    typealias DBTIQuestionsResponseDTO = BaseDTO<DBTIQuestionsResponse>
    typealias DBTIResultResponseDTO = BaseDTO<DBTIResultResponse>
}

final class DBTIAPIService: BaseAPIService, DBTIAPIServiceProtocol {
    
    private let provider = MoyaProvider<DBTIAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// DBTI 질문 조회
    func fetchDBTIQuestions(
        completion: @escaping (NetworkResult<DBTIQuestionsResponseDTO>) -> Void
    ) {
        self.request(
            .fetchDBTIQuestions,
            provider: provider,
            responseType: DBTIQuestionsResponseDTO.self,
            completion: completion
        )
    }
    
    /// DBTI 검사 제출
    func submitDBTI(
        petId: Int,
        request: DBTISurveyRequest,
        completion: @escaping (NetworkResult<DBTIResultResponseDTO>) -> Void
    ) {
        self.request(
            .submitDBTI(petId: petId, request: request),
            provider: provider,
            responseType: DBTIResultResponseDTO.self,
            completion: completion
        )
    }
    
    /// DBTI 결과 조회
    func fetchDBTIResult(
        petId: Int,
        completion: @escaping (NetworkResult<DBTIResultResponseDTO>) -> Void
    ) {
        self.request(
            .fetchDBTIResult(petId: petId),
            provider: provider,
            responseType: DBTIResultResponseDTO.self,
            completion: completion
        )
    }
}
