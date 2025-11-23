//
//  BackButton.swift
//  PAWKEY
//
//  Created by 권석기 on 9/21/25.
//

import SwiftUI

struct BackButton: View {
    let action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(.btnBack)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    BackButton {}
}
