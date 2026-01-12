//
//  PetProfile.swift
//  DOKI
//
//  Created by 안치욱 on 12/29/25.
//

import SwiftUI

struct PetProfile: View {
    let name: String
    let dbti: String
    let petInfo: String
    let action: ()->()
    
    var body: some View {
        Button(action: action) {
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
                        AddressTag(text: dbti)
                        HStack(spacing: 4) {
                            Text(name)
                                .subtitle()
                            Text(petInfo)
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
}
