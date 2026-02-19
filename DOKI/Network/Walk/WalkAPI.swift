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
}

extension WalkAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .preparationMessage:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .preparationMessage:
            return "/walk/preparation/message"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .preparationMessage:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .preparationMessage:
            return .requestPlain
        }
    }
}
