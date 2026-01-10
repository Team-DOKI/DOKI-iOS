//
//  MyProfile.swift
//  DOKI
//
//  Created by 안치욱 on 12/28/25.
//

import SwiftUI

struct MyProfile: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("키큰오팔전차 님")
                    .mainActive()
                Text("hello@gmail.com")
                    .subDefault()
                    .accentColor(.defaultMiddle)
            }
            Spacer()
            Image(.btnMore)
        }
        .frame(height: 74)
        .padding(16)
        .background(.defaultBackground)
        .cornerRadius(8)
    }
}
