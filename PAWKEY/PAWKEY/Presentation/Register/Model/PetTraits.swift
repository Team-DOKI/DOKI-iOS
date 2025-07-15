//
//  PetTraits.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

struct PetTraitCategory {
    let categoryId: Int
    let categoryName: String
    let categoryOptions: [PetTraitCategoryOption]
}

struct PetTraitCategoryOption {
    let categoryOptionId: Int
    let categoryOptionText: String
}
