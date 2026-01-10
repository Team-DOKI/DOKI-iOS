//
//  AppleLoginRequestDTO.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

struct AppleLoginRequestDTO: Encodable {
    let idToken: String
    let deviceId: String
}
