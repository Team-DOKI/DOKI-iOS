//
//  FilterSettingView.swift
//  DOKI
//
//  Created by a on 11/3/25.
//

import SwiftUI

struct FilterSettingView: View {
    var body: some View {
        VStack {
            
        }
        .topNavigationView(left: {
            BackButton {
                
            }
        }, center: {
            Text("필터링 선택")
                .subtitle()
        })
    }
}

#Preview {
    FilterSettingView()
}
