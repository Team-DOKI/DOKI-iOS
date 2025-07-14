//
//  ActivityAreaMapAPI.swift
//  PAWKEY
//
//  Created by 이세민 on 7/14/25.
//

import Foundation

import Moya

enum ActivityAreaMapAPI {
    case fetchCoordinates(regionId: Int)
    case updateUserRegion(regionId: Int)
}

extension ActivityAreaMapAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchCoordinates, .updateUserRegion:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchCoordinates(let regionId):
            return "regions/\(regionId)/geometry"
        case .updateUserRegion:
            return "users/me/regions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCoordinates:
            return .get
        case .updateUserRegion:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchCoordinates:
            return .requestPlain
        case .updateUserRegion(let regionId):
            return .requestParameters(
                parameters: ["regionId": regionId],
                encoding: JSONEncoding.default
            )
        }
    }
}
