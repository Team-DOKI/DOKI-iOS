//
//  DBTIQuestionsResponse.swift
//  DOKI
//
//  Created by 이세민 on 2/20/26.
//

import Foundation

struct DBTIQuestionsResponse: Codable {
    let questions: [Question]
}

struct Question: Codable {
    let id: Int
    let category: Category
    let content: String
    let options: [Option]
}

struct Category: Codable {
    let code: String
    let name: String
}

struct Option: Codable {
    let id: Int
    let content: String
    let imageUrl: String
    let value: String
}
