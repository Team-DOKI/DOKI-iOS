//
//  ReviewChart.swift
//  DOKI
//
//  Created by a on 1/11/26.
//

import SwiftUI

struct ReviewChart: View {
    let text: String
    let rank: Int
    
    var chartColor: Color {
        switch rank {
        case 1: .primaryGra5
        case 2: .primaryGra2
        case 3: .primaryGra1
        default: Color.red
        }
    }
    
    var widthRatio: CGFloat {
        switch rank {
        case 1: return 1.0
        case 2: return 0.7
        case 3: return 0.4
        default: return 0.3
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            Text(text)
                .subActive()
                .padding(12)
                .frame(
                    width: geo.size.width * widthRatio,
                    alignment: .leading
                )
                .background(chartColor)
                .cornerRadius(6)
        }
        .frame(height: 37)
    }
}

#Preview {
    ReviewChart(text: "후기 옵션", rank: 1)
}
