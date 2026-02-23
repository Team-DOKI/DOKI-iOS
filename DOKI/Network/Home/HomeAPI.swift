//
//  HomeAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

import Foundation
import Moya

enum HomeAPI {
    case fetchWeather // 날씨 조회
    case fetchWalkInfo // 산책 정보(누적) 조회
}

extension HomeAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchWeather:
            return "home/weather"
        case .fetchWalkInfo:
            return "home/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWeather, .fetchWalkInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchWeather, .fetchWalkInfo:
            return .requestPlain
        }
    }
}
