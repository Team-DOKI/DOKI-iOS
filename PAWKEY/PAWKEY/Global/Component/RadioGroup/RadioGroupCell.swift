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
            Text(checkOption.title)
                .font(checkOption.isSelected ? .body_14_r : .body_14_sb)
                .foregroundStyle(checkOption.isSelected ? .green : .black)
            Spacer()
            Image(checkOption.isSelected ? .radioButtonAct : .radioButtonDeact)
        }
        .frame(height: 61)
    }
}

//#Preview {
//    RadioGroupCell()
//}
