//
//  AppleLoginRequestDTO.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

struct AppleLoginRequestDTO: Encodable {
    let authorizationCode: String
    let deviceId: String
}
