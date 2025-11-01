////
////  UserAPI.swift
////  PAWKEY
////
////  Created by 권석기 on 7/15/25.
////
//
//import Foundation
//
//import Moya
//
//enum UserAPI {
//    case updateUserProfile(UserProfile)
//}
//
//extension UserAPI: BaseTargetType {
//    var headerType: HeaderType {
//        switch self {
//        case .updateUserProfile:
//            return .userHeader(userId: 2)
//        }
//    }
//    
//    var path: String {
//        switch self {
//        case .updateUserProfile:
//            return "users"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        case .updateUserProfile:
//            return .post
//        }
//    }
//    
//    var task: Task {
//        switch self {
//        case let .updateUserProfile(userProfile):
//            
//            var multipartData: [MultipartFormData] = []
//            
//            if let jsonData = try? JSONEncoder().encode(userProfile.toDto()) {
//                multipartData.append(MultipartFormData(
//                    provider: .data(jsonData),
//                    name: "data",
//                    mimeType: "application/json"
//                ))
//            }
//            
//            if let image = userProfile.profileImage {
//                multipartData.append(MultipartFormData(
//                    provider: .data(userProfile.profileImage?.pngData() ?? Data()),
//                    name: "pet_profile",
//                    fileName: "pet_profile1.jpg",
//                    mimeType: "multipart/form-data"
//                ))
//            }
//            return .uploadMultipart(multipartData)
//        }
//    }
//}
