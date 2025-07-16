//
//  WalkPostRequestDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

struct FilterRequest: Codable {
    var durationStart: String?
    var durationEnd: String?
    var selectedOptions: [SelectedOption]
}

struct SelectedOption: Codable {
    var categoryId: Int?
    var optionsIds: [Int]?
}

