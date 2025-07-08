//
//  CheckBoxCell.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct CheckBoxCell: View {
    let title: String
    var body: some View {
        HStack {
            Text("차량 거의 없음")
                .font(.body_14_r)
            Spacer()
            Image(.rectCheckFill)
        }
        .frame(height: 61)
    }
}

#Preview {
    CheckBoxCell(title: "")
}
