//
//  DBTIResultDTO.swift
//  DOKI
//
//  Created by 안치욱 on 2/15/26.
//


import Foundation

struct DBTIResultDTO: Codable {
    let type: String
    let name: String
    let image: String
    let keyword: [String]
    let description: String
    let analysis: [DBTIAxisAnalysisDTO]
}

struct DBTIAxisAnalysisDTO: Codable {
    let axis: String
    let leftLabel: String
    let rightLabel: String
    let dominantSide: String
    let score: Int
}

enum DominantSide: String, Codable { case left, right }

struct DBTIResult: Hashable {
    let type: String
    let name: String
    let imageURL: URL?
    let keywords: [String]
    let description: String
    let analysis: [DBTIAxisAnalysis]
}

struct DBTIAxisAnalysis: Hashable {
    let axis: String
    let leftLabel: String
    let rightLabel: String
    let dominantSide: DominantSide
    let score: Int
}

extension DBTIResultDTO {
    func toDomain() -> DBTIResult {
        .init(
            type: type,
            name: name,
            imageURL: URL(string: image),
            keywords: keyword,
            description: description,
            analysis: analysis.map { $0.toDomain() }
        )
    }
}

extension DBTIAxisAnalysisDTO {
    func toDomain() -> DBTIAxisAnalysis {
        .init(
            axis: axis,
            leftLabel: leftLabel,
            rightLabel: rightLabel,
            dominantSide: DominantSide(rawValue: dominantSide) ?? .left,
            score: score
        )
    }
}
