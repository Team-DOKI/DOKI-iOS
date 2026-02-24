//
//  WalkAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/18/26.
//

import Foundation

import Moya

enum WalkAPI {
    case preparationMessage // 산책 준비 메세지
    case fetchPreparation // 산책 준비물 조회
}

extension WalkAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .preparationMessage:
            return "/walk/preparation/message"
        case .fetchPreparation:
            return "/walk/preparation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .preparationMessage, .fetchPreparation:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .preparationMessage, .fetchPreparation:
            return .requestPlain
        }
    }
}
