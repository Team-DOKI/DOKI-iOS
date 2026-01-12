//
//  MyWalkRecordView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MyWalkRecordView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("내가 기록한 산책")
            .topNavigationView(left: {
                BackButton(action: {
                    dismiss()
                })
            }, center: {
                Text("내가 기록한 산책")
                    .subtitle()
            })
    }
}

#Preview {
    MyWalkRecordView()
}
