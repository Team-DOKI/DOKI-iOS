//
//  FilterCategoryResponse.swift
//  DOKI
//
//  Created by 권석기 on 3/5/26.
//

struct FilterCategoryResponse: Codable {
    let durationList: [CategoryItem]
    let categoryList: [CategoryItem]
}

struct CategoryItem: Codable {
    let id: Int
    let name: String
    let selectionType: String
    let options: [CategoryOptionItem]
}

struct CategoryOptionItem: Codable {
    let id: Int
    let text: String
}
