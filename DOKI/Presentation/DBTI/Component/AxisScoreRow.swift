//
//  AxisScoreRow.swift
//  DOKI
//
//  Created by 안치욱 on 2/14/26.
//

import SwiftUI

struct AxisScoreRow: View {
    let data: AxisAnalysisData
    
    private let total = 3
    private var isLeftDominant: Bool {
        data.dominantSide == "left"
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(data.leftLabel)
                .font(isLeftDominant ? .bodyBold : .bodyDefault)
                .foregroundStyle(isLeftDominant ? .contents : .defaultMiddle)
            
            HStack(spacing: 2) {
                ForEach(0..<total, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 57, height: 10)
                        .foregroundStyle(
                            (isLeftDominant
                             ? index < data.score
                             : index >= total - data.score)
                            ? .primaryGra5
                            : .defaultBright
                        )
                }
            }
            
            Text(data.rightLabel)
                .font(isLeftDominant ? .bodyDefault : .bodyBold)
                .foregroundStyle(isLeftDominant ? .defaultMiddle : .contents)
        }
    }
}
