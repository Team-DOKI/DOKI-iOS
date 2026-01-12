//
//  MyReviewView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MyReviewView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("내가 남긴 후기")
            .topNavigationView(left: {
                BackButton(action: {
                    dismiss()
                })
            }, center: {
                Text("내가 남긴 후기")
                    .subtitle()
            })
    }
}

#Preview {
    MyReviewView()
}
