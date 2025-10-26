//
//  HomeView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        Button {
            viewModel.navigateToWalkRecord()
        } label: {
            Text("산책시작")
        }
    }
}
