//
//  WalkHistoryCard.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/10/25.
//

import SwiftUI

enum cardType {
case mine
case others
    
    var iconName: Image {
        switch self {
        case .mine:
            Image(.eyeFill)
        case .others:
            Image(.heartIconGray)
        }
    }
    
}

struct WalkHistoryCard: View {
    
    let type: cardType
    let walkRouteImg: String
    let profileImg: String
    let walkTitle: String
    let petName: String
    let postDate: String
    var buttonPressed: Bool = false
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            // 상단 프로필
            HStack {
                // 반려견 사진
                Image(profileImg)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 43, height: 43)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(walkTitle)
                        .font(.body_14_m)
                        .foregroundStyle(Color.green500)
                    
                    HStack {
                            Text(petName)
                                .font(.caption_12_sb)
                            
                            Text(postDate)
                                .font(.caption_12_r)
                                .foregroundStyle(Color.gray300)
                    }
                }
                .padding(.leading, 10)
                
                Spacer()
                
                Button {
            
                } label: {
                    if type == .mine {
                        buttonPressed ? Image(.eyeSlashFill) : type.iconName
                    }
                    else {
                        buttonPressed ? Image(.heartIconFill) : type.iconName
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // 옵션 칩들
            HStack {
                Chip(title: "옵션", isActive: false)
                Chip(title: "오션", isActive: false)
                Chip(title: "좋아요", isActive: false)
                Spacer()
            }
            .padding(.leading, 16)
            
            // 지도 SnapShot
            Image(walkRouteImg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.horizontal, 16)
            
            Divider()
                .padding(.horizontal, 16)
        }
    }
}


#Preview {
    WalkHistoryCard(type: .others, walkRouteImg: "walkRoute", profileImg: "profile", walkTitle: "산책띠", petName: "길냥이", postDate: "2025/07/07", buttonPressed: true)
}
