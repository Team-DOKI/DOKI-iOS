//
//  FilterDataMapper.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

extension Array where Element == SelectListDTO {
    func toEntity() -> [SelectList] {
        map {
            SelectList(
                selectId: $0.selectId,
                selectName: $0.selectName,
                options: $0.options.toEntity()
            )
        }
    }
}

extension Array where Element == CategoryListDTO {
    func toEntity() -> [SelectList] {
        map {
            SelectList(
                selectId: $0.categoryId,
                selectName: $0.categoryName,
                options: $0.options.toEntity()
            )
        }
    }
}


extension SelectListDTO {
    func toEntity() -> SelectList {
        SelectList(
            selectId: selectId,
            selectName: selectName,
            options: options.toEntity()
        )
    }
}

extension Array where Element == SelectItemDTO {
    func toEntity() -> [SelecteItem] {
        map {
            SelecteItem(
                selectOptionId: $0.selectOptionId,
                selectText: $0.selectText
            )
        }
    }
}

extension CategoryListDTO {
    func toEntity() -> SelectList {
        SelectList(
            selectId: categoryId,
            selectName: categoryName,
            options: options.toEntity()
        )
    }
}

extension Array where Element == CategoryItemDTO {
    func toEntity() -> [SelecteItem] {
        map {
            SelecteItem(
                selectOptionId: $0.categoryOptionId,
                selectText: $0.optionText
            )
        }
    }
}
