//
//  DBTIQuestionData.swift
//  DOKI
//
//  Created by 이세민 on 2/21/26.
//

import Foundation

struct DBTIQuestionData {
    let title: String
    let question: String
    let options: [DBTIOptionsData]
}

struct DBTIOptionsData {
    let id: Int
    let content: String
    let imageUrl: String
}
