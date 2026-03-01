//
//  ReviewData.swift
//  DOKI
//
//  Created by 이세민 on 3/2/26.
//

import Foundation

struct ReviewData: Identifiable {
    let id: Int
    let title: String
    let address: String
    let date: String
    let tags: [String]
}
