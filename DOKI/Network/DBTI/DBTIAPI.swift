//
//  DBTIAPI.swift
//  DOKI
//
//  Created by 이세민 on 2/27/26.
//

import Foundation
import Moya

enum DBTIAPI {
    case fetchDBTIQuestions // DBTI 질문 조회
    case submitDBTI(petId: Int, request: DBTISurveyRequest) // DBTI 검사 제출
    case fetchDBTIResult(petId: Int) // DBTI 결과 조회
}

extension DBTIAPI: BaseTargetType {
    
    var headerType: HeaderType {
        .defaultHeader
    }
    
    var path: String {
        switch self {
        case .fetchDBTIQuestions:
            return "pets/dbti/questions"
        case let .submitDBTI(petId, _),
            let .fetchDBTIResult(petId):
            return "pets/dbti/\(petId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDBTIQuestions, .fetchDBTIResult:
            return .get
        case .submitDBTI:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchDBTIQuestions, .fetchDBTIResult:
            return .requestPlain
        case let .submitDBTI(_, request):
            return .requestJSONEncodable(request)
        }
    }
}
