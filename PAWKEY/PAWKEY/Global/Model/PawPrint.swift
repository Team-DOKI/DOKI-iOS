//
//  PawPrint.swift
//  PAWKEY
//
//  Created by 이세민 on 7/12/25.
//

import Foundation

struct PawPrint: Identifiable, Equatable {
    let id = UUID()
    let position: CGPoint
    var opacity: Double = 1.0
}
