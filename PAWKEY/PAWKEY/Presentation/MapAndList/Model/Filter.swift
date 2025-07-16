//
//  Filter.swift
//  PAWKEY
//
//  Created by 권석기 on 7/16/25.
//

import Foundation

struct FilterList {
    var selecteList: [SelectList] = []
    var categoryList: [SelectList] = []
}

struct SelectList: Hashable {
    let selectId: Int
    let selectName: String
    var options: [SelecteItem]
}

struct SelecteItem: Hashable {
    let selectOptionId: Int
    let selectText: String
    var isSelected: Bool = false
}
