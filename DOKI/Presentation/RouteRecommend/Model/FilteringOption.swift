//
//  FilteringOption.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import Foundation

struct FilteringOption: Identifiable, Hashable {
    let id = UUID()
    let text: String
    var isActive: Bool
    var category: String?
}
