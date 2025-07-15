//
//  PetTraits.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import Foundation

struct PetTraitCategory: Hashable {
    let categoryId: Int
    let categoryName: String
    var categoryOptions: [PetTraitCategoryOption]
}

struct PetTraitCategoryOption: Hashable {
    let categoryOptionId: Int
    let categoryOptionText: String
    var isSelected: Bool = false
}

extension Array where Element == PetTraitCategory {
    func isSelected(categoryId: Int, optionId: Int) -> Bool {
        guard let category = self.first(where: { $0.categoryId == categoryId }) else {
            return false
        }
        return category.categoryOptions.contains(where: { $0.categoryOptionId == optionId && $0.isSelected })
    }
}
