//
//  WalkRecordView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkRecordView: View {
    @StateObject var viewModel: WalkRecordViewModel    
    
    var body: some View {
        Button {
            viewModel.navigateToWalkReview()
        } label: {
            Text("산책 종료하기")
        }
        .navigationTitle(Text("산책기록"))
    }
}

