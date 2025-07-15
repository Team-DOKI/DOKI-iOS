//
//  PetTraitsCategoryDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

struct PetTraitData: Decodable {
    let petTraitCategoryList: [PetTraitCategory]
}

struct PetTraitCategory: Decodable {
    let petTraitCategoryId: Int
    let petTraitCategoryName: String
    let petTraitCategoryOptions: [PetTraitCategoryOption]
}

struct PetTraitCategoryOption: Decodable {
    let petTraitCategoryOptionId: Int
    let petTraitCategoryOptionText: String
}
