//
//  BaseAPIService.swift
//  DOKI
//
//  Created by 이세민 on 2/17/26.
//

import Foundation

class BaseAPIService {

    func fetchNetworkResult<T: Decodable>(statusCode: Int, data: Data) -> NetworkResult<T> {
        switch statusCode {
        case 200, 201:
            guard let decoded = fetchDecodeData(data: data, responseType: T.self)
            else { return .decodeError }
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
