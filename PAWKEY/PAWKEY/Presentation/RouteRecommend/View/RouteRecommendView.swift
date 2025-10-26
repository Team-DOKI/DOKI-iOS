//
//  RouteRecommendView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct RouteRecommendView: View {
    @ObservedObject var viewModel: RecommendViewModel
    
    var body: some View {
        List(1..<100) { num in
            Button {
                viewModel.navigateToDetail(id: num)
            } label: {
                Text("id: \(num)")
            }
        }

    }
}

//#Preview {
//    RouteRecommendView()
//}
