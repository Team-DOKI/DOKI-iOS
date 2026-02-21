//
//  AxisAnalysisData.swift
//  DOKI
//
//  Created by 이세민 on 2/21/26.
//

import Foundation

struct AxisAnalysisData: Identifiable {
    let id = UUID()
    let leftLabel: String
    let rightLabel: String
    let dominantSide: String
    let score: Int
}
