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
    let profileAction: () -> Void
    let dbtiAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: profileAction) {
                HStack(spacing: 16) {
                    let url = URL(string: imageUrl ?? "")
                    
                    AsyncImage(url: (imageUrl?.isEmpty == false) ? URL(string: imageUrl!) : nil) { image in
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
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name).subtitle()
                        
                        Text(petInfo).subDefault(color: .defaultMiddle)
                    }
                    
                    Spacer()
                }
                .padding(.top, 16)
            }
            .buttonStyle(.plain)
            
            Divider()
                .background(.defaultButton)
            
            Button(action: dbtiAction) {
                Text(dbti)
                    .bodyBold(color: .defaultPrimary)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(.primaryGra1)
                    .cornerRadius(8)
                    .padding(.bottom, 16)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .background(.defaultBackground)
        .cornerRadius(8)
    }
}
