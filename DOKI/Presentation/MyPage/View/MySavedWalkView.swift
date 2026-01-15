//
//  MySavedWalkView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MySavedWalkView: View {
    @ObservedObject var viewModel: MySavedWalkViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...10, id: \.self) { _ in
                    WalkCourseCell()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
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

