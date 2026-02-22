//
//  BaseAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

import Foundation
import Moya

class BaseAPIService {
    
    /// 공통 request
    func request<T: Decodable, Target: Moya.TargetType>(
        _ target: Target,
        provider: MoyaProvider<Target>,
        responseType: T.Type,
        completion: @escaping (NetworkResult<T>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }
            
            let networkResult: NetworkResult<T>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure:
                networkResult = .networkFail
            }
            
            // 401 처리
            switch networkResult {
            case .unAuthorized:
                self.handleUnauthorized(target: target, provider: provider, responseType: responseType, completion: completion)
            default:
                completion(networkResult)
            }
        }
    }
    
    // MARK: - 401 처리 (토큰 재발급)
    
    private func handleUnauthorized<T: Decodable, Target: Moya.TargetType>(
        target: Target,
        provider: MoyaProvider<Target>,
        responseType: T.Type,
        completion: @escaping (NetworkResult<T>) -> Void
    ) {
        AuthManager.shared.refreshToken { refreshed in
            if refreshed {
                self.request(target, provider: provider, responseType: responseType, completion: completion)
            } else {
                completion(.unAuthorized)
            }
        }
    }
    
    // MARK: - StatusCode 처리
    
    func fetchNetworkResult<T: Decodable>(statusCode: Int, data: Data) -> NetworkResult<T> {
        switch statusCode {
        case 200, 201:
            guard let decoded = fetchDecodeData(data: data, responseType: T.self) else {
                return .decodeError
            }
            return .success(decoded)
        case 204:
            return .success(nil)
        case 400: return .badRequest
        case 401: return .unAuthorized
        case 404: return .notFound
        case 405: return .methodNotAllowed
        case 409: return .conflict
        case 500: return .serverError
        default: return .networkFail
        }
    }
    
    func fetchNetworkResult(statusCode: Int) -> NetworkResult<Void> {
        switch statusCode {
        case 200, 201, 204: return .success(nil)
        case 400: return .badRequest
        case 401: return .unAuthorized
        case 404: return .notFound
        case 405: return .methodNotAllowed
        case 409: return .conflict
        case 500: return .serverError
        default: return .networkFail
        }
    }
    
    private func fetchDecodeData<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("BaseAPIService 디코딩 실패:", error)
            return nil
        }
    }
}
