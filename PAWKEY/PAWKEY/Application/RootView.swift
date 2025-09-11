//
//  RootView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
//    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    var body: some View {
        HStack {
            CheckBox(text: "남아", isChecked: true)
            CheckBox(text: "여아", isChecked: false)
        }
    }
}
