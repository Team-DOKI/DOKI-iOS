//
//  CheckOption.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import Foundation

struct CheckOption: Identifiable, Equatable {
    var id = UUID()
    let title: String
    var isSelected: Bool
}
