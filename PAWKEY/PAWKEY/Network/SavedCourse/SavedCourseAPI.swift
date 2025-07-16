//
//  SavedCourseAPI.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/16/25.
//


import Foundation

import Moya

enum SavedCourseAPI {
    case getSavedCourse
}

extension SavedCourseAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getSavedCourse:
            return .userHeader(userId: 4)
        }
    }
    
    var path: String {
        switch self {
        case .getSavedCourse:
            return "users/me/likes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSavedCourse:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getSavedCourse:
            return .requestPlain
        }
    }
}
