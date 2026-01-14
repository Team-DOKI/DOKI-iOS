//
//  MenuItem.swift
//  DOKI
//
//  Created by a on 1/12/26.
//

import SwiftUI

struct MenuItem: View {
    let title: String
    let icon: Image
    let action: ()->()
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                icon
                Spacer().frame(width: 8)
                Text(title)
                    .bodyDefault()
                Spacer()
                Image(.btnMore)
            }
            .frame(height: 56)
        }
    }
}
