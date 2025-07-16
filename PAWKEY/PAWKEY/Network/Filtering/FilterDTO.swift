//
//  FilterDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

struct FilterDTO: Codable {
    let selectList: [SelectListDTO]
    let categoryList: [CategoryListDTO]
}

struct SelectListDTO: Codable {
    let selectId: Int
    let selectName: String
    let options: [SelectItemDTO]
}

struct SelectItemDTO: Codable {
    let selectOptionId: Int
    let selectText: String
}

struct CategoryListDTO: Codable {
    let categoryId: Int
    let categoryName: String
    let categoryDescription: String
    let options: [CategoryItemDTO]
}

struct CategoryItemDTO: Codable {
    let categoryOptionId: Int
    let optionText: String
}



