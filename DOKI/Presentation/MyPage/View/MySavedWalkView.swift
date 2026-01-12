//
//  MySavedWalkView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MySavedWalkView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("저장목록")
            .topNavigationView(left: {
                BackButton(action: {
                    dismiss()
                })
            }, center: {
                Text("저장목록")
                    .subtitle()
            })
    }
}

#Preview {
    MySavedWalkView()
}
