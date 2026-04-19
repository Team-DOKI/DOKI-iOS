//
//  AuthInterceptor.swift
//  DOKI
//
//  Created by a on 12/9/25.
//

import Foundation

import Moya
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    static let shared = AuthInterceptor()
    private init() {}

    // header에 AccessToken 추가
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if request.url?.absoluteString.contains("auth/refresh") == true {
            completion(.success(request))
            return
        }
        if let token = AuthManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    // 401 응답 시 토큰 재발급 후 재시도
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            request.retryCount == 0
        else {
            completion(.doNotRetry)
            return
        }

        // refresh 엔드포인트 자체는 재시도 안 함
        if request.request?.url?.absoluteString.contains("auth/refresh") == true {
            completion(.doNotRetry)
            return
        }

        AuthManager.shared.refreshToken { refreshed in
            completion(refreshed ? .retry : .doNotRetry)
        }
    }
}
