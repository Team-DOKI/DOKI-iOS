//
//  StatBox.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI

struct StatBox: View { // TODO: 묶자.
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption_12_sb)
                .foregroundColor(.gray500)
            
            Text(value)
                .font(.head_20_b)
                .foregroundColor(.green500)
        }
        .frame(width: 67, height: 42)
    }
}
