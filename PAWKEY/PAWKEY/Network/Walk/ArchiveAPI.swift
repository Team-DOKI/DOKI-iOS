//
//  ArchiveAPI.swift
//  PAWKEY
//
//  Created by 이세민 on 7/15/25.
//

import Foundation
import Moya

enum ArchiveAPI {
    case fetchCourseInfo(routeId: Int)
    case fetchCourseCategories
    case postCourse(body: ArchivePostDTO, images: [Data]?)
}

extension ArchiveAPI: BaseTargetType {
    var headerType: HeaderType {
        switch self {
        case .fetchCourseInfo, .fetchCourseCategories, .postCourse:
            return .userHeader(userId: 2)
        }
    }
    
    var path: String {
        switch self {
        case .fetchCourseInfo(let routeId):
            return "routes/\(routeId)/info"
        case .fetchCourseCategories:
            return "posts/categories"
        case .postCourse:
            return "posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postCourse:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchCourseInfo, .fetchCourseCategories:
            return .requestPlain
            
        case .postCourse(let body, let images):
            var multipartData: [MultipartFormData] = []
            
            if let jsonData = try? JSONEncoder().encode(body) {
                let jsonPart = MultipartFormData(
                    provider: .data(jsonData),
                    name: "data",
                    mimeType: "application/json"
                )
                multipartData.append(jsonPart)
            }
            
            if let images = images {
                for (index, imageData) in images.enumerated() {
                    let imagePart = MultipartFormData(
                        provider: .data(imageData),
                        name: "images",
                        fileName: "snapshot\(index).jpg",
                        mimeType: "multipart-form-data"
                    )
                    multipartData.append(imagePart)
                }
            }
            return .uploadMultipart(multipartData)
        }
    }
    
}
