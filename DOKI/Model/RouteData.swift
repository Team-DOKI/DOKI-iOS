//
//  RouteData.swift
//  DOKI
//
//  Created by 이세민 on 2/28/26.
//

import Foundation

struct RouteData: Identifiable {
    let id: Int
    let title: String
    let address: String
    let date: String
    let duration: String
    var isLiked: Bool
    let imageURL: String
}
