//
//  CourseDetailView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct CourseDetailView: View {
    @ObservedObject var viewModel: CourseDetailViewModel
    
    var body: some View {
        Button {
            viewModel.navigateToBack()
        } label: {
            Text("id: \(viewModel.id)")
            Text("뒤로가기")
        }
    }
}

//#Preview {
//    CourseDetailView()
//}
