//
//  WalkPreparationData.swift
//  DOKI
//
//  Created by 이세민 on 1/10/26.
//

import Foundation

struct WalkPreparationData: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var isChecked: Bool

    static func == (lhs: WalkPreparationData, rhs: WalkPreparationData) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.isChecked == rhs.isChecked
    }
}
