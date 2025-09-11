//
//  RootView.swift
//  PAWKEY
//
//  Created by 권석기 on 7/15/25.
//

import SwiftUI

struct RootView: View {
//    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    @State var text1 = ""
    @State var text2 = ""
    @State var text3 = ""
    
    var body: some View {
        MainTextField(placeholder: "text", text: $text1)
        MainTextField(placeholder: "text", text: $text2)
        SearchField(placeholder: "text", text: $text3)
    }
}
