//
//  NetworkResult.swift
//  PAWKEY
//
//  Created by 이세민 on 6/21/25.
//

import Foundation

enum NetworkResult<T> {
    
    case success(T?)
    
    case networkFail
    case decodeError
    case badRequest
    case notFound
    case serverError
    
    var errorDescription: String {
        switch self {
        case .success(_):
            return "네트워크 통신 성공"
        case .networkFail:
            return "네트워크 통신 실패"
        case .decodeError:
            return "디코딩 실패"
        case .badRequest:
            return "유효하지 않은 요청"
        case .notFound:
            return "404"
        case .serverError:
            return "서버 에러"
        }
    }
}
