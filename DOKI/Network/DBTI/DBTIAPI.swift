//
//  DBTIAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/27/26.
//

import Foundation
import Moya

enum DBTIAPI {
    case fetchQuestions // DBTI 질문 조회
    case submitDBTI(petId: Int, request: DBTISurveyRequest) // DBTI 검사 제출
}

extension DBTIAPI: BaseTargetType {
    
    var headerType: HeaderType {
        .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchQuestions:
            return "pets/dbti/questions"
        case let .submitDBTI(petId, _):
            return "pets/dbti/\(petId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchQuestions:
            return .get
        case .submitDBTI:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchQuestions:
            return .requestPlain
        case let .submitDBTI(_, request):
            return .requestJSONEncodable(request)
        }
    }
}
