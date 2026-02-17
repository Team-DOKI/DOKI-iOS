//
//  PetProfile.swift
//  DOKI
//
//  Created by 안치욱 on 12/29/25.
//

import SwiftUI

struct PetProfile: View {
    let name: String
    let petInfo: String
    let imageUrl: String?
    let dbti: String
    let action: ()->()
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    if let imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(.imgDefaultprofile)
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    } else {
                        Image(.imgDefaultprofile)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .subtitle()
                        
                        Text(petInfo)
                            .subDefault(color: .defaultMiddle)
                    }
                    
                    Spacer()
                }
                .padding(.top, 16)
    
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.defaultButton)
                
                Text(dbti)
                    .bodyBold(color: .defaultPrimary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(.primaryGra1)
                    .cornerRadius(8)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            .background(.defaultBackground)
            .cornerRadius(8)
        }
    }
}
