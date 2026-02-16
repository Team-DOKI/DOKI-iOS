//
//  DBTIResultCardView.swift
//  DOKI
//
//  Created by 안치욱 on 2/16/26.
//

import SwiftUI

struct DBTIResultCardView: View {
    let result: DBTIResult

    var body: some View {
        VStack(spacing: 0) {

            Text("내 강아지의 성향은")
                .bodyActive(color: .defaultDark)
                .padding(.top, 32)

            Text(result.name)
                .header2(color: .black)
                .padding(.top, 16)

            Text(result.type)
                .header1(color: .defaultPrimary)

            AsyncImage(url: result.imageURL) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFit()
                default:
                    Rectangle().opacity(0.06)
                }
            }
            .frame(width: 150, height: 150)
            .padding(.top, 20)

            HStack(spacing: 8) {
                ForEach(result.keywords, id: \.self) { k in
                    Text("#\(k)")
                        .subActive(color: .defaultPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(.primaryGra1)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.top, 24)

            Text(result.description)
                .bodyActive(color: .contents)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.top, 24)

            VStack(spacing: 16) {
                ForEach(result.analysis, id: \.self) { item in
                    AxisBarRow(axis: item)
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 20)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
