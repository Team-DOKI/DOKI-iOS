//
//  DBTIAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/27/26.
//

import Foundation
import Moya

enum DBTIAPI {
    case fetchQuestions
}

extension DBTIAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .fetchQuestions:
            return .defaultHeader
        }
    }
    
    var path: String {
        switch self {
        case .fetchQuestions:
            return "pets/dbti/questions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchQuestions:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchQuestions:
            return .requestPlain
        }
    }
}
