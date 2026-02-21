//
//  AppleLoginRequest.swift
//  DOKI
//
//  Created by a on 12/7/25.
//

import Foundation

struct AppleLoginRequest: Codable {
    let authorizationCode: String
    let deviceId: String
}
