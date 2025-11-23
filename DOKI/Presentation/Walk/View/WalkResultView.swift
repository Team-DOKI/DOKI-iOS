//
//  WalkResultView.swift
//  PAWKEY
//
//  Created by a on 10/26/25.
//

import SwiftUI

struct WalkResultView: View {
    @StateObject var viewModel: WalkResultViewModel
    
    var body: some View {
        Button {            
            viewModel.navigateBackToRoot()
        } label: {
            Text("처음으로")
        }
    }
}
