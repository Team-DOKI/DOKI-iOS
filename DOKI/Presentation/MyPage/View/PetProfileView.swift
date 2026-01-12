//
//  PetProfileView.swift
//  DOKI
//
//  Created by 안치욱 on 12/30/25.
//

import SwiftUI

struct PetProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("Hello, World!")
            .topNavigationView(left: {
                BackButton(action: {
                    dismiss()
                })
            }, center: {
                Text("반려견 정보 입력")
                    .subtitle()
            })
    }
}
