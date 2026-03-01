//
//  RefreshTokenResponse.swift
//  DOKI
//
//  Created by 이세민 on 2/21/26.
//

struct RefreshTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
