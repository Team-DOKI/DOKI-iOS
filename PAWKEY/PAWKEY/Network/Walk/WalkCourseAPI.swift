//
//  WalkCourseAPI.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import Foundation
import Moya

enum WalkCourseAPI {
    case postWalkCourse(body: WalkCourseRequestDTO, image: Data?)
}

extension WalkCourseAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case let .postWalkCourse(_, _):
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .postWalkCourse:
            return "routes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postWalkCourse:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .postWalkCourse(body, image):
            var multipartData: [MultipartFormData] = []
            
            if let jsonData = try? JSONEncoder().encode(body) {
                multipartData.append(MultipartFormData(
                    provider: .data(jsonData),
                    name: "routeRequest",
                    mimeType: "application/json"
                ))
            }
            
            if let image = image {
                multipartData.append(MultipartFormData(
                    provider: .data(image),
                    name: "trackingImage",
                    fileName: "snapshot.jpg",
                    mimeType: "multipart-form-data"
                ))
            }
            
            return .uploadMultipart(multipartData)
        }
    }
}
