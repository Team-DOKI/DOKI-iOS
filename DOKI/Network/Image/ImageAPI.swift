//
//  ImageAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/16/26.
//

import Foundation
import Moya

enum ImageAPI {
    case presigned(request: PresignedUrlRequest)
    case register(request: RegisterImageRequest)
}

extension ImageAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .presigned, .register:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .presigned:
            return "images/presigned"
        case .register:
            return "images/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .presigned, .register:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .presigned(request):
            return .requestJSONEncodable(request)
        case let .register(request):
            return .requestJSONEncodable(request)
        }
    }
}
