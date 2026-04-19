//
//  PostUpdateRequest.swift
//  DOKI
//

import Foundation

struct PostUpdateRequest: Codable {
    let title: String
    let description: String
    let walkImageIds: [Int]
    let selectedOptionsForCategories: [SelectedOption]
    let isPublic: Bool
}
