//
//  AxisBarRow.swift
//  DOKI
//
//  Created by 안치욱 on 2/14/26.
//

import SwiftUI

struct AxisBarRow: View {
    let axis: DBTIAxisAnalysis
    private let total: Int = 3
    
    @State private var animatedScore: Int = 0
    
    private var isLeftDominant: Bool {
        axis.dominantSide == .left
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Text(axis.leftLabel)
                    .font(isLeftDominant ? .bodyBold : .bodyDefault)
                    .foregroundStyle(isLeftDominant ? .contents : .defaultMiddle)

                cells()
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(axis.rightLabel)
                    .font(isLeftDominant ? .bodyDefault : .bodyBold)
                    .foregroundStyle(isLeftDominant ? .defaultMiddle : .contents)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animatedScore = axis.score
            }
        }
    }

    private func cells() -> some View {
        HStack(spacing: 2) {
            ForEach(0..<total, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 57, height: 10)
                    .foregroundStyle(fillColor(for: index))
            }
        }
    }
    
    private func fillColor(for index: Int) -> Color {
        switch axis.dominantSide {
        case .left:
            return index < animatedScore ? .primaryGra5 : .defaultBright
            
        case .right:
            return index >= total - animatedScore ? .primaryGra5 : .defaultBright
        }
    }
}
