//
//  MoyaConcurrency.swift
//  DOKI
//
//  Created by 권석기 on 7/14/25.
//

import Foundation
import Moya

extension MoyaProvider {
    
    class MoyaConcurrency {
        
        private let provider: MoyaProvider
        
        init(provider: MoyaProvider) {
            self.provider = provider
        }
        
        func request<T: Decodable>(_ target: Target) async throws -> T {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(target) { result in
                    switch result {
                    case .success(let response):
                        guard let res = try? JSONDecoder.default.decode(T.self, from: response.data) else {
                            continuation.resume(throwing: MoyaError.jsonMapping(response))
                            return
                        }
                        continuation.resume(returning: res)
                    case .failure(let error):          
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
        
        func requestPlain(_ target: Target) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(target) { result in
                    switch result {
                    case .success:
                        continuation.resume(returning: ())
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }

        /// 2xx 응답이 아니면 throw
        func requestPlainChecked(_ target: Target) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                provider.request(target) { result in
                    switch result {
                    case .success(let response):
                        guard (200..<300).contains(response.statusCode) else {
                            continuation.resume(throwing: MoyaError.statusCode(response))
                            return
                        }
                        continuation.resume(returning: ())
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    var async: MoyaConcurrency {
        MoyaConcurrency(provider: self)
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

