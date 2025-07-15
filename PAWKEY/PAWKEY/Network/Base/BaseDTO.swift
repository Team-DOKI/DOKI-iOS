//
//  BaseDTO.swift
//  PAWKEY
//
//  Created by 이세민 on 6/21/25.
//

import Foundation

struct BaseDTO<T: Codable>: Codable {
    let code: String
    let message: String
    let data: T?
}
