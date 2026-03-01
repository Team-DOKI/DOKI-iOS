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
    case fetchTotalWalkStat // 누적 산책 정보 조회
}

extension HomeAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchWeather:
            return "home/weather"
        case .fetchTotalWalkStat:
            return "home/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWeather, .fetchTotalWalkStat:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchWeather, .fetchTotalWalkStat:
            return .requestPlain
        }
    }
}
