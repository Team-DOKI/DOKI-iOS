//
//  PostRegisterRequest.swift
//  DOKI
//
//  Created by 권석기 on 3/12/26.
//

import Foundation

struct PostRegisterRequest: Codable {
    let title: String
    let description: String
    let isPublic: Bool
    let selectedOptionsForCategories: [SelectedOption]
    let routeId: Int
    let routeImageId: Int
    let walkImageIds: [Int]
}

struct SelectedOption: Codable {
    let categoryId: Int
    let selectedOptionIds: [Int]
}
