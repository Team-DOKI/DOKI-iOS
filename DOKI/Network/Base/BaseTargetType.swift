//
//  BaseTargetType.swift
//  PAWKEY
//
//  Created by 이세민 on 6/21/25.
//

import Foundation

import Moya

enum HeaderType {
    case defaultHeader
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
}

extension BaseTargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("Invalid BASE_URL format")
        }
        return url
    }
    
    var headers: [String: String]? {
        switch headerType {
        case .defaultHeader:
            return ["Content-Type": "application/json"]    
        }
    }
}
