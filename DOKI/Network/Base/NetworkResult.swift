//
//  NetworkResult.swift
//  DOKI
//
//  Created by 이세민 on 6/21/25.
//

import Foundation

enum NetworkResult<T> {
    case success(T?)
    
    case networkFail
    case decodeError
    case badRequest
    case unAuthorized
    case notFound
    case methodNotAllowed
    case conflict
    case serverError
    
    var errorDescription: String {
        switch self {
        case .success(_): return "네트워크 통신 성공"
        case .networkFail: return "네트워크 통신 실패"
        case .decodeError: return "디코딩 실패"
        case .badRequest: return "유효하지 않은 요청"
        case .unAuthorized: return "인증 실패"
        case .notFound: return "404 Not Found"
        case .methodNotAllowed: return "허용되지 않은 메서드"
        case .conflict: return "충돌 발생"
        case .serverError: return "서버 에러"
        }
    }
}
