//
//  AppleLoginResponse.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

struct AppleLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
    let userId: Int
    let petId: Int
}
