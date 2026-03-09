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
    
    /// 산책 준비물 조회
    func fetchPreparation(completion: @escaping (NetworkResult<PreparationResponseDTO>) -> Void)
    
    /// 산책 준비물 저장(동기화)
    func savePreparation(
        request: PreparationRequest,
        completion: @escaping (NetworkResult<PreparationResponseDTO>) -> Void
    )
    
    /// 산책 시작
    func startWalk(
        request: WalkStartRequest,
        completion: @escaping (NetworkResult<WalkStartResponseDTO>) -> Void
    )
    
    /// 산책 스트리밍
    func streamWalk(
        request: WalkStreamRequest,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    )
    
    /// 산책 종료
    func finishWalk(
        routeId: String,
        request: WalkFinishRequest,
        completion: @escaping (NetworkResult<WalkFinishResponseDTO>) -> Void
    )
}

extension WalkAPIServiceProtocol {
    typealias PreparationMessageResponseDTO = BaseDTO<PreparationMessageResponse>
    typealias PreparationResponseDTO = BaseDTO<PreparationResponse>
    typealias WalkStartResponseDTO = BaseDTO<WalkStartResponse>
    typealias WalkFinishResponseDTO = BaseDTO<WalkFinishResponse>
}

final class WalkAPIService: BaseAPIService, WalkAPIServiceProtocol {
    
    private let provider = MoyaProvider<WalkAPI>(
        session: MoyaSession.shared,
        plugins: [MoyaLoggingPlugin()]
    )
    
    // MARK: - API
    
    /// 산책 준비 메세지 조회
    func fetchPreparationMessage(
        completion: @escaping (NetworkResult<PreparationMessageResponseDTO>) -> Void
    ) {
        self.request(.fetchPreparationMessage,
                     provider: provider,
                     responseType: PreparationMessageResponseDTO.self,
                     completion: completion)
    }
    
    /// 산책 준비물 조회
    func fetchPreparation(
        completion: @escaping (NetworkResult<PreparationResponseDTO>) -> Void
    ) {
        request(
            .fetchPreparation,
            provider: provider,
            responseType: PreparationResponseDTO.self,
            completion: completion
        )
    }
    
    /// 산책 준비물 저장(동기화)
    func savePreparation(
        request: PreparationRequest,
        completion: @escaping (NetworkResult<PreparationResponseDTO>) -> Void
    ) {
        self.request(
            .savePreparation(request),
            provider: provider,
            responseType: PreparationResponseDTO.self,
            completion: completion
        )
    }
    
    /// 산책 시작
    func startWalk(
        request: WalkStartRequest,
        completion: @escaping (NetworkResult<WalkStartResponseDTO>) -> Void
    ) {
        self.request(
            .startWalk(request),
            provider: provider,
            responseType: WalkStartResponseDTO.self,
            completion: completion
        )
    }
    
    /// 산책 스트리밍
    func streamWalk(
        request: WalkStreamRequest,
        completion: @escaping (NetworkResult<BaseDTO<EmptyResponse>>) -> Void
    ) {
        self.request(
            .streamWalk(request),
            provider: provider,
            responseType: BaseDTO<EmptyResponse>.self,
            completion: completion
        )
    }
    
    /// 산책 종료
    func finishWalk(
        routeId: String,
        request: WalkFinishRequest,
        completion: @escaping (NetworkResult<WalkFinishResponseDTO>) -> Void
    ) {
        self.request(
            .finishWalk(routeId, request),
            provider: provider,
            responseType: WalkFinishResponseDTO.self,
            completion: completion
        )
    }
}
