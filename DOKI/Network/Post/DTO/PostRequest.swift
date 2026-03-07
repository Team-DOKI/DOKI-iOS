//
//  PostRequest.swift
//  DOKI
//
//  Created by 권석기 on 3/7/26.
//

struct PostRequest {
    let selectedOption: [PostOption]
}

struct PostOption {
    let durationId: Int?
    let categoryId: Int?
    let optionsIds: [Int]
}
