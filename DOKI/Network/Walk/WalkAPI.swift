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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPreparationMessage, .fetchPreparation:
            return .get
        case .savePreparation:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchPreparationMessage, .fetchPreparation:
            return .requestPlain
        case .savePreparation(let request):
            return .requestJSONEncodable(request)
        }
    }
}
