//
//  DBTIResultResponse.swift
//  DOKI
//
//  Created by 안치욱 on 2/15/26.
//

import Foundation

struct DBTIResultResponse: Codable {
    let type: String
    let name: String
    let image: String
    let keyword: [String]
    let description: String
    let analysis: [Analysis]
}

struct Analysis: Codable {
    let axis: String
    let leftLabel: String
    let rightLabel: String
    let dominantSide: String
    let score: Int
}
