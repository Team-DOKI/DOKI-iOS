//
//  AppInfoView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct AppInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("앱 설정")
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .topNavigationView(left: {
            BackButton(action: {
                dismiss()
            })
        }, center: {
            Text("앱 정보")
                .subtitle()
        })
    }
}

#Preview {
    AppInfoView()
}
