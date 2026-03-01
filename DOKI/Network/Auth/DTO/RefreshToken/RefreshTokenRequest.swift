//
//  RefreshTokenRequest.swift
//  DOKI
//
//  Created by 이세민 on 2/21/26.
//

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
    let deviceId: String
}
