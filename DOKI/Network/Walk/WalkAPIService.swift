//
//  WalkAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/18/26.
//

import Foundation
import Moya

protocol WalkAPIServiceProtocol {
    /// 산책 준비 메세지 조회
    func fetchPreparationMessage(completion: @escaping (NetworkResult<PreparationMessageResponseDTO>) -> Void)
}

extension WalkAPIServiceProtocol {
    typealias PreparationMessageResponseDTO = BaseDTO<PreparationMessageResponse>
}

final class WalkAPIService: BaseAPIService, WalkAPIServiceProtocol {
    
    private let provider = MoyaProvider<WalkAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    /// 산책 준비 메세지 조회
    func fetchPreparationMessage(
        completion: @escaping (NetworkResult<PreparationMessageResponseDTO>) -> Void
    ) {
        self.request(.preparationMessage,
                     provider: provider,
                     responseType: PreparationMessageResponseDTO.self,
                     completion: completion)
    }
}
