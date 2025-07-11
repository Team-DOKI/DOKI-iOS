//
//  TimePlaceCell.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI

struct TimePlaceCell: View {
    enum CellType {
        case place(String)
        case time(String)
    }
    
    let type: CellType
    
    private var icon: Image {
        switch type {
        case .place:
            return Image(.locationGreen)
        case .time:
            return Image(.clockGreen)
        }
    }
    
    private var text: String {
        switch type {
        case .place(let placeText):
            return placeText
        case .time(let timeText):
            return timeText
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            icon
            Text(text)
                .font(.body_14_m)
                .foregroundColor(.gray400)
        }
    }
}
