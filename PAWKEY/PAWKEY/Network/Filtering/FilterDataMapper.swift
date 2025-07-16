//
//  FilterDataMapper.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

extension Array where Element == SelectListDTO {
    func toEntity(startingId: Int = 1) -> [SelecteList] {
        var currentId = startingId
        return self.map { dto in
            let newOptions = dto.options.enumerated().map { idx, opt in
                SelecteItem(
                    selectOptionId: currentId * 100 + idx,
                    selectText: opt.selectText,
                    isSelected: false
                )
            }
            defer { currentId += 1 }
            return SelecteList(
                selectId: currentId,
                selectName: dto.selectName,
                options: newOptions
            )
        }
    }
}

extension Array where Element == CategoryListDTO {
    func toEntity(startingId: Int = 100) -> [SelecteList] {
        var currentId = startingId
        return self.map { dto in
            let newOptions = dto.options.enumerated().map { idx, opt in
                SelecteItem(
                    selectOptionId: currentId * 100 + idx,
                    selectText: opt.optionText,
                    isSelected: false
                )
            }
            defer { currentId += 1 }
            return SelecteList(
                selectId: currentId,
                selectName: dto.categoryName,
                options: newOptions
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
