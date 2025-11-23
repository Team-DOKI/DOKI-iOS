//
//  SectionHeader.swift
//  DOKI
//
//  Created by a on 11/14/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title).subtitle()
            
            Text(subtitle).subDefault(color: .defaultMiddle)
            
            Spacer()
        }
    }
}

#Preview {
    SectionHeader(title: "혼잡도", subtitle: "(단일 선택 가능")
}
