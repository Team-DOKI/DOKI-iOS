//
//  BackButton.swift
//  PAWKEY
//
//  Created by 권석기 on 7/9/25.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(.chevronLeft)
        }

    }
}

#Preview {
    BackButton(action: {})
}
