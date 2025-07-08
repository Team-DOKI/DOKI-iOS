//
//  RadioGroupCell.swift
//  PAWKEY
//
//  Created by 권석기 on 7/8/25.
//

import SwiftUI

struct RadioGroupCell: View {
    let checkOption: CheckOption
    var body: some View {
        HStack {
            Text("차량 거의 없음")
                .font(.body_14_r)
            Spacer()
            Image(checkOption.isSelected ? .radioButtonAct : .radioButtonDeact)
        }
        .frame(height: 61)
    }
}

//#Preview {
//    RadioGroupCell()
//}
