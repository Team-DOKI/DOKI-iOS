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
        HStack {
            Text(title).subtitle()
            Text(subtitle).subDefault(color: .default)
            Spacer()
        }
    }
}

