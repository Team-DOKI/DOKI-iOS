//
//  AppleLoginResponseDTO.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

struct AppleLoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
}
