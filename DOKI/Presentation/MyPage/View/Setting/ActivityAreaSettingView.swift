//
//  ActivityAreaSettingView.swift
//  DOKI
//
//  Created by a on 1/13/26.
//

import SwiftUI

struct ActivityAreaSettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("활동 범위 설정")
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .topNavigationView(left: {
            BackButton(action: {
                dismiss()
            })
        }, center: {
            Text("활동 범위 설정")
                .subtitle()
        })
    }
}

#Preview {
    ActivityAreaSettingView()
}
