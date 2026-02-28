//
//  ImageAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/16/26.
//

import Foundation
import Moya

enum ImageAPI {
    case presignedURL(request: PresignedURLRequest) // Presigned URL 요청
    case registerImage(request: RegisterImageRequest) // 이미지 등록
}

extension ImageAPI: BaseTargetType {
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var path: String {
        switch self {
        case .presignedURL:
            return "images/presigned"
        case .registerImage:
            return "images/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .presignedURL, .registerImage:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .presignedURL(request):
            return .requestJSONEncodable(request)
        case let .registerImage(request):
            return .requestJSONEncodable(request)
        }
    }
}
