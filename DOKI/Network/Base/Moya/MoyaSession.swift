//
//  MoyaSession.swift
//  DOKI
//
//  Created by 이세민 on 2/7/26.
//

import Alamofire
import Moya
import Foundation

final class MoyaSession {
    static let shared: Session = {
        let configuration = URLSessionConfiguration.default
        return Session(
            configuration: configuration,
            interceptor: AuthInterceptor.shared
        )
    }()
}
