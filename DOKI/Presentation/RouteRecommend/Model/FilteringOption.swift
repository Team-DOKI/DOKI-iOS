//
//  FilteringOption.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import Foundation

struct FilteringOption: Identifiable, Hashable {
    let id: Int
    let text: String
    var isActive: Bool
}

extension Array where Element == FilteringOption {
    mutating func reset() {
        self = self.map {
            var option = $0
            option.isActive = false
            return option
        }
    }
}
