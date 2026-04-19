//
//  RouteTag.swift
//  DOKI
//
//  Created by a on 1/11/26.
//

import SwiftUI

struct RouteTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .subActive(color: .defaultPrimary)
            .padding(8)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .background(.primaryGra1)
            .cornerRadius(8)
    }
}

#Preview {
    RouteTag(text: "혼잡도 보통")
}
