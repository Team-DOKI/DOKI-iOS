//
//  AppleLoginResponseDTO.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

struct AppleLoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
