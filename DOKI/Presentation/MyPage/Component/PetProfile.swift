//
//  PetProfile.swift
//  DOKI
//
//  Created by 안치욱 on 12/29/25.
//

import SwiftUI

struct PetProfile: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("반려견 프로필")
                    .subActive(color: .defaultBackground)
                Spacer()
            }
            .frame(height: 36)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.defaultPrimary)
            HStack(spacing: 16) {
                Image(.imgDefaultprofile)
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 4) {
                    AddressTag(text: "동네인기스타 bbb")
                    HStack(spacing: 4) {
                        Text("단지")
                            .subtitle()
                        Text("6개월 / 여아 / 견종 이름")
                            .subDefault(color: .defaultMiddle)
                    }
                }
                Spacer()
            }
            .frame(height: 100)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(.defaultBackground)
        }
        .cornerRadius(8)
    }
}
