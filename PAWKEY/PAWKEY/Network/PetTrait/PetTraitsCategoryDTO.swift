//
//  PetTraitsCategoryDTO.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

struct PetTraitDTO: Codable {
    let petTraitCategoryList: [PetTraitCategoryDTO]
}

struct PetTraitCategoryDTO: Codable {
    let petTraitCategoryId: Int
    let petTraitCategoryName: String
    let petTraitCategoryOptions: [PetTraitCategoryOptionDTO]
}

struct PetTraitCategoryOptionDTO: Codable {
    let petTraitCategoryOptionId: Int
    let petTraitCategoryOptionText: String
}

extension PetTraitCategoryDTO {
    func toEntity() -> PetTraitCategory {
        PetTraitCategory(
            categoryId: petTraitCategoryId,
            categoryName: petTraitCategoryName,
            categoryOptions: petTraitCategoryOptions.toEntity(categoryId: petTraitCategoryId)
        )
    }
}

extension Array where Element == PetTraitCategoryOptionDTO  {
    func toEntity(categoryId: Int) -> [PetTraitCategoryOption] {
        map {
            PetTraitCategoryOption(                
                categoryOptionId: $0.petTraitCategoryOptionId,
                categoryOptionText: $0.petTraitCategoryOptionText
            )
        }
    }
}



