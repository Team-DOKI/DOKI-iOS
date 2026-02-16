//
//  DBTISurveyDTO.swift
//  DOKI
//
//  Created by 안치욱 on 2/15/26.
//

import Foundation

struct DBTISurveyResponseDTO: Codable {
    let questions: [DBTIQuestionDTO]
}

struct DBTIQuestionDTO: Codable {
    let id: Int
    let category: DBTICategoryDTO
    let content: String
    let options: [DBTIOptionDTO]
}

struct DBTICategoryDTO: Codable {
    let code: String
    let name: String
}

struct DBTIOptionDTO: Codable {
    let id: Int
    let content: String
    let imageUrl: String
    let value: String
}

struct DBTIQuestion: Identifiable, Hashable {
    let id: Int
    let categoryCode: String
    let categoryName: String
    let content: String
    let options: [DBTIOption]
}

struct DBTIOption: Identifiable, Hashable {
    let id: Int
    let content: String
    let imageURL: URL?
    let value: String
}

extension DBTIQuestionDTO {
    func toDomain() -> DBTIQuestion {
        .init(
            id: id,
            categoryCode: category.code,
            categoryName: category.name,
            content: content,
            options: options.map { $0.toDomain() }
        )
    }
}

extension DBTIOptionDTO {
    func toDomain() -> DBTIOption {
        .init(
            id: id,
            content: content,
            imageURL: URL(string: imageUrl),
            value: value
        )
    }
}

struct DBTISubmitPayload: Codable, Hashable {
    let eiOptionIds: [Int]
    let psOptionIds: [Int]
    let rtOptionIds: [Int]
}
