//
//  CheckItem.swift
//  DOKI
//
//  Created by 권석기 on 3/9/26.
//

import Foundation

struct CheckItem: Hashable {
    let id = UUID()
    let isChecked: Bool
    let text: String
}
