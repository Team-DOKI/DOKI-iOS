//
//  FilterDataMapper.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

extension Array where Element == SelectListDTO {
    func toEntity() -> [SelecteList] {
        map {
            SelecteList(
                selectId: $0.selectId,
                selectName: $0.selectName,
                options: $0.toEntity().options
            )
        }
    }
}

extension Array where Element == CategoryListDTO {
    func toEntity() -> [SelecteList] {
        map {
            SelecteList(
                selectId: $0.categoryId,
                selectName: $0.categoryName,
                options: $0.toEntity().options
            )
        }
    }
}

extension SelectListDTO {
    func toEntity() -> SelecteList {
        SelecteList(
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
    func toEntity() -> SelecteList {
        SelecteList(
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
