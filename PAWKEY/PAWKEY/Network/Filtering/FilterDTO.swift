//
//  FilterDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

struct FilterDTO {
    let selectList: [SelectListDTO]
    let categoryList: [CategoryListDTO]
}

struct SelectListDTO {
    let selectId: Int
    let selectName: String
    let options: [SelecteItemDTO]
}

struct SelecteItemDTO {
    let selectOptionId: Int
    let selectText: String
}

struct CategoryListDTO {
    let categoryId: Int
    let categoryName: String
    let options: [SelecteItemDTO]
}

struct CategoryItemDTO {
    let categoryOptionId: Int
    let optionText: String
}
