//
//  HomeAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

import Foundation
import Moya

enum HomeAPI {
    case fetchWeather
}

extension HomeAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchWeather:
            return "home/weather"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWeather:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchWeather:
            return .requestPlain
        }
    }
}
