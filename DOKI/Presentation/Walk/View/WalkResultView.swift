//
//  WalkResultView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkResultView: View {
    @StateObject var viewModel: WalkResultViewModel
    
    var body: some View {
        Button {
            viewModel.navigateToWalkReview()
        } label: {
            Text("후기 작성하기")
        }
        .navigationTitle("산책 완료")
    }
}
