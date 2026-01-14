//
//  WalkItem.swift
//  DOKI
//
//  Created by 이세민 on 1/10/26.
//

import Foundation

struct WalkItem: Identifiable {
    let id = UUID()
    var name: String
    var isChecked: Bool
}
