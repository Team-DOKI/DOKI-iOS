//
//  FilterMapper.swift
//  DOKI
//
//  Created by 권석기 on 3/5/26.
//

extension FilterCategoryResponse {
    func toEntities() -> [FilterList]  {
        let durationList = self.durationList.map {
            FilterList(
                id: $0.id,
                filterType: FilterType.matchFilterType($0.name),
                selectionType: $0.selectionType,
                options: $0.options.toEntity(),
                name: $0.name
            )
        }
        let categoryList = self.categoryList.map {
            FilterList(
                id: $0.id,
                filterType: FilterType.matchFilterType($0.name),
                selectionType: $0.selectionType,
                options: $0.options.toEntity(),
                name: $0.name
            )
        }
        return categoryList + durationList
    }
}

extension Array where Element == CategoryOptionItem {
    func toEntity() -> [FilteringOption] {
        map { FilteringOption(id: $0.id, text: $0.text, isActive: false) }
    }
}
