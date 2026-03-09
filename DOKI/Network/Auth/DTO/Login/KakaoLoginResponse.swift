//
//  KakaoLoginResponse.swift
//  DOKI
//
//  Created by 권석기 on 3/8/26.
//

import Foundation

struct KakaoLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
}
