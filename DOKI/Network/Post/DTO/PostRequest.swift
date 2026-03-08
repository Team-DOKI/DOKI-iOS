//
//  PostRequest.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

import Foundation

struct PostRequest: Encodable{
    let selectedOption: [PostOption]
}

struct PostOption: Encodable {
    var durationId: Int?
    var categoryId: Int?
    let optionsIds: [Int]
}
