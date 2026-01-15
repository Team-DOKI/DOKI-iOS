//
//  CourseReviewView.swift
//  DOKI
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct CourseReviewView: View {
    @StateObject var viewModel: CourseReviewViewModel
    
    var body: some View {
        Button {
            viewModel.navigateToWalkResult()
        } label: {
            Text("후기 작성하기")
        }
        .navigationTitle("산책 완료")
    }
}
