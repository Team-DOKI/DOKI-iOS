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
        case 3: .primaryGra2
        default: Color.red
            
        }
    }
    
    var body: some View {
        Text(text)
            .bodySmall()
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(chartColor)
            .cornerRadius(6)
    }
}

#Preview {
    ReviewChart(text: "후기 옵션", rank: 1)
}
