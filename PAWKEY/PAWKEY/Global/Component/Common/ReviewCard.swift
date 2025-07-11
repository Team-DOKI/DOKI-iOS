//
//  ReviewCard.swift
//  PAWKEY
//
//  Created by 안치욱 on 7/10/25.
//

import SwiftUI

struct ReviewCard: View {
    
    enum CardType {
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
    
    @State var type: CardType
    @State var walkRouteImg: String
    @State var profileImg: String
    @State var walkTitle: String
    @State var petName: String
    @State var postDate: String
    @State var buttonPressed: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Image(walkRouteImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        // 그라데이션 오버레이
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pawkeyBlack.opacity(0.5), .clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                // 상단 프로필
                HStack {
                    // 반려견 사진
                    Image(profileImg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 43, height: 43)
                        .clipShape(Circle())
                        .padding(.bottom, 12)
                    
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(walkTitle)
                            .font(.body_14_m)
                            .foregroundStyle(Color.pawkeyWhite1)
                        
                        HStack {
                            Text(petName)
                                .font(.caption_12_sb)
                                .foregroundStyle(Color.gray50)
                            
                            Text(postDate)
                                .font(.caption_12_r)
                                .foregroundStyle(Color.gray100)
                        }
                    }
                    .padding(.leading, 10)
                    .padding(.bottom, 12)
                    
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
                .padding(.horizontal, 10)
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)
                  
            VStack(spacing: 0) {
                let data = ["이륜차 거의 없음", "배변 쓰레기통", "쉼터", "편의점", "동반 카페", "아스팔트/벽돌", "시끌벅적"]
                FlexibleGrid(availableWidth: UIScreen.main.bounds.size.width - 32, data: data, spacing: 8, alignment: .leading) {
                    Chip(title: $0, isActive: true)
                }
            }
            .padding(16)
            .fixedSize(horizontal: false, vertical: true)
        }
        .background(Color.pawkeyWhite1)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

}

#Preview {
    ZStack {
        Color.gray
        ReviewCard(type: .others, walkRouteImg: "walkRoute", profileImg: "profile", walkTitle: "외로운 산책", petName: "길냥이", postDate: "2025/01/02", buttonPressed: true)
    }
}
