//
//  MyPageView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var router: TabRouter<MyPageScreen>
    //@State var ownerName: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 제목
            VStack(spacing: 24) {
                HStack {
                    Text("마이페이지")
                        .font(.head_20_b)
                        .padding(.top, 20)
                        .padding(.leading, 16)
                    Spacer()
                }
                
                // 견주 프로필
                HStack {
                    HStack {
                        Text("김도기")
                            .font(.head_18_sb)
                            .foregroundColor(.pawkeyBlack)
                        Text("님")
                            .font(.head_18_sb)
                            .foregroundColor(.pawkeyBlack)
                        Text("견주")
                            .font(.caption_12_m)
                            .foregroundColor(.gray400)
                    }
                    
                    Spacer()
                    
                    Button {
                        router.push(.userProfile)
                    } label: {
                        Image(.arrowRightGray)
                    }
                    .padding(.vertical, 16)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.pawkeyWhite1)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .frame(width: 343, height: 79)
                
                // 반려견 프로필
                VStack(spacing: 0) {
                    HStack {
                        Image(.idCard)
                        Text("반려견 프로필")
                            .font(.body_16_sb)
                            .foregroundColor(.pawkeyWhite1)
                        Spacer()
                        Button {
                            router.push(.petProfile)
                        } label: {
                            Image(.arrowRightWhite)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color.green500)
                    
                    VStack {
                        VStack {
                            HStack {
                                Image(.profile)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("삼색이")
                                        .font(.head_18_sb)
                                    Text("12세 · 여아")
                                        .font(.caption_12_r)
                                        .foregroundColor(.gray300)
                                }
                                .padding(.leading, 8)
                                
                                Spacer()
                            }
                            .padding(.top, 16)
                            
                            HStack {
                                Chip(title: "#조금느긋해요", isActive: false)
                                Chip(title: "#오토바이소리", isActive: false)
                                Chip(title: "#대형견", isActive: false)
                                Spacer()
                            }
                            .padding(.top, 16)
                        }
                        .padding(.leading, 16)
                        
                        HStack {
                            VStack(alignment: .center, spacing: 8) {
                                Text("산책 횟수")
                                    .font(.caption_12_r)
                                Text("7회")
                                    .font(.head_20_b)
                                    .foregroundStyle(Color.green500)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Divider()
                                .foregroundStyle(Color.gray100)
                                .frame(height: 38)
                            
                            VStack(alignment: .center, spacing: 8) {
                                Text("누적 거리")
                                    .font(.caption_12_r)
                                Text("14km")
                                    .font(.head_20_b)
                                    .foregroundStyle(Color.green500)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 20)
                    }
                }
                .background(Color.pawkeyWhite1)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .frame(width: 343, height: 255)
                
                
                // 산책관리
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        Text("산책 루트 관리")
                            .font(.caption_12_sb)
                            .foregroundColor(.gray400)
                            .padding(.top, 16)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    
                    HStack {
                        HStack(spacing: 12) {
                            Image(.heartIconBlack)
                            Text("저장한 산책 루트")
                                .font(.body_16_sb)
                        }
                        
                        Spacer()
                        
                        Button {
                            router.push(.savedRoute)
                        } label: {
                            Image(.arrowRightBlack20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.gray50)
                    
                    HStack {
                        HStack(spacing: 12) {
                            Image(.editIconBlack)
                            Text("내가 기록한 산책 루트")
                                .font(.body_16_sb)
                        }
                        
                        Spacer()
                        Button {
                        } label: {
                            Image(.arrowRightBlack20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.gray50)
                }
                .background(Color.white)
                
                Spacer()
                
            }
        }
        .background(Color.pawkeyWhite2)
    }
}
