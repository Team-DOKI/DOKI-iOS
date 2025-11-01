//
//  HomeView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State var item = "text1"
    
    var body: some View {
        VStack {            
            SegmentedButton(items: ["text1", "text2", "text3"], selectedItem: $item)
            Button {
                viewModel.navigateToWalkRecord()
            } label: {
                Text("산책시작")
            }
        }
    }
}
