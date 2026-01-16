//
//  SectionHeader.swift
//  DOKI
//
//  Created by a on 11/14/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String?
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title).subtitle()
            
            if let subtitle {
                Text(subtitle)
                    .subDefault(color: .defaultMiddle)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SectionHeader(title: "편의성", subtitle: "(복수 선택 가능)")
}
