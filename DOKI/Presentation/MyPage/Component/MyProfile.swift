//
//  MyProfile.swift
//  DOKI
//
//  Created by 안치욱 on 12/28/25.
//

import SwiftUI

struct MyProfile: View {
    let nickname: String
    let email: String
    var action: ()->()
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(nickname)
                        .mainActive()
                    
                    Text(email)
                        .subDefault(color: .defaultMiddle)
                        .accentColor(.defaultMiddle)
                }
                
                Spacer()
                
                Image(.btnMore)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(.defaultBackground)
            .cornerRadius(8)
        }
    }
}
