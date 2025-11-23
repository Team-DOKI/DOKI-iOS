//
//  CourseReviewView.swift
//  PAWKEY
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
            Text("산책 결과")
        }
    }
}
