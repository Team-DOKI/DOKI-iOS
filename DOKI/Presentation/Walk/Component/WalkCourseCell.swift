//
//  WalkCourseCell.swift
//  DOKI
//
//  Created by a on 11/2/25.
//

import SwiftUI

struct WalkCourseCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("")
                .resizable()
                .frame(height: 212)
                .background(.defaultButton)
                .cornerRadius(8)
                .overlay(alignment: .top) {
                    HStack {
                        AddressTag(text: "강남구 역삼동")
                        Spacer()
                        Image(.heartIcon)
                    }
                    .padding(8)
                }
            Text("오늘도 단지랑 룰루랄라")
                .bodyBold()
                .padding(.top, 8)
            Text("현재거리로부터 2km")
                .subDefault(color: .defaultMiddle)
                .padding(.top, 4)
            HStack {
                HStack(spacing: 4) {
                    Image(.calendarIcon)
                    Text("20205/09/19")
                        .small(color: .defaultMiddle)
                }
                HStack(spacing: 4) {
                    Image(.clockIcon)
                    Text("30min")
                        .small(color: .defaultMiddle)
                }
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    HStack {
        WalkCourseCell()
        WalkCourseCell()
    }
    .padding()
}
