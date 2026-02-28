//
//  MyWalkRecordView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct MyWalkRecordView: View {
    @ObservedObject var viewModel: MyWalkRecordViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(1...10, id: \.self) { _ in
                    RouteCell()
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
                Text("내가 기록한 산책")
                    .subtitle()
            })
    }
}

