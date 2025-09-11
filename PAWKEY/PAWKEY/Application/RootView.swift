//
//  RootView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
    @State var isLoading = false
    var body: some View {
        VStack {
            MainButton(text: "Test", buttonState: isLoading ? .loading : .default) {
                isLoading = true
            }
        }
        .padding(.horizontal, 20)
    }
}
