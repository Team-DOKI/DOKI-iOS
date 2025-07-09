//
//  LocationDateView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI

struct LocationDateView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(.locationGreen)
                Text("강남구 역삼동")
                    .font(.body_14_m)
                    .foregroundColor(.gray400)
            }
            .padding(.bottom, 10)
            
            HStack(alignment: .center) {
                Image(.clockGreen)
                Text("2025.07.08(화) | 오후 11:28")
                    .font(.body_14_m)
                    .foregroundColor(.gray400)
            }
            .padding(.bottom, 12)
            
            Text("옵션")
                .font(.body_14_m)
                .foregroundStyle(.gray200)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.pawkeyWhite2)
                .cornerRadius(4)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}
