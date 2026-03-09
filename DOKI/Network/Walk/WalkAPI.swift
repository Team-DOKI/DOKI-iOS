//
//  WalkAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/18/26.
//

import Foundation

import Moya

enum WalkAPI {
    case fetchPreparationMessage // 산책 준비 메세지 조회
    case fetchPreparation // 산책 준비물 조회
    
    case savePreparation(PreparationRequest) // 산책 준비물 저장(동기화)
    
    case startWalk(WalkStartRequest) // 산책 시작
    case streamWalk(WalkStreamRequest) // 산책 스트리밍
    case finishWalk(String, WalkFinishRequest) // 산책 종료
}

extension WalkAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchPreparationMessage:
            return "walk/preparation/message"
        case .fetchPreparation, .savePreparation:
            return "walk/preparation"
        case .startWalk:
            return "walks/stream/start"
        case .streamWalk:
            return "walks/stream/point"
        case .finishWalk(let routeId, _):
            return "routes/\(routeId)/finish"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPreparationMessage, .fetchPreparation:
            return .get
        case .savePreparation:
            return .patch
        case .startWalk, .streamWalk, .finishWalk:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchPreparationMessage, .fetchPreparation:
            return .requestPlain
        case .savePreparation(let request):
            return .requestJSONEncodable(request)
        case .startWalk(let request):
            return .requestJSONEncodable(request)
        case .streamWalk(let request):
            return .requestJSONEncodable(request)

        case .finishWalk(_, let request):
            return .requestJSONEncodable(request)
        }
    }
}
