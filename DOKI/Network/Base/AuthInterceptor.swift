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
}
