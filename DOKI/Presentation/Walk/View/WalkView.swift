//
//  WalkView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkView: View {
    @StateObject var viewModel: WalkViewModel
    
    var body: some View {
        Button {
            viewModel.navigateToWalkRecord()
        } label: {
            Text("산책시작")
        }

    }
}

