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
    
    // 네트워크 요청하기 전 헤더에 accessToken 추가
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        
        if request.url?.absoluteString.contains("auth/refresh") == true {
            completion(.success(request))
            return
        }
        if let accessToken = AuthManager.shared.accessToken {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        // 401인 경우가 아니라면 종료
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // refreshToken 가져오기 없다면 종료
        guard let refreshToken = AuthManager.shared.refreshToken?.replacingOccurrences(of: "\"", with: "") else {
            completion(.doNotRetry)
            AuthManager.shared.logoutLocal()
            return
        }
        
        // 토큰 재발급 API 호출 & 토큰 교체
        var refreshRequest = URLRequest(url: URL(string: Config.baseURL + "auth/refresh")!)
        refreshRequest.httpMethod = "POST"
        refreshRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deviceId = DeviceIDManager.shared.getDeviceId()
        
        let requestBody = try? JSONSerialization.data(
            withJSONObject: [
                "refreshToken": refreshToken,
                "deviceId": deviceId
            ]
        )
        refreshRequest.httpBody = requestBody
        let defaultSession = URLSession(configuration: .default)
        
        defaultSession.dataTask(with: refreshRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            // 에러 발생시 재요청 x
            guard error == nil else {
                completion(.doNotRetry)
                AuthManager.shared.logoutLocal()
                return
            }
            
            guard let data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                completion(.doNotRetry)
                AuthManager.shared.logoutLocal()
                return
            }
            
            // 토큰 재발급 요청 성공
            do {
                let response = try JSONDecoder().decode(AppleLoginResponseDTO.self, from: data)
                // 토큰 재발급
                AuthManager.shared.reissueToken(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
                // 재요청
                print("토큰 재발급 성공 - 재요청")
                completion(.retry)
            } catch {
                print("토큰 재발급 실패 - 로그아웃")
                completion(.doNotRetryWithError(error))
                AuthManager.shared.logoutLocal()
            }
        }.resume()
    }
}
