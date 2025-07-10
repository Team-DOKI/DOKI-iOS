//
//  PetProfileView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct PetProfileView: View {
    @EnvironmentObject var router: TabRouter<MyPageScreen>
    
    var body: some View {
        VStack(spacing: 8) {
            Image(.profile)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 108, height: 108)
                .clipShape(Circle())
                .padding(.vertical, 36)
                .overlay {
                    Circle()
                        .stroke(Color.green500, lineWidth: 2)
                }
            
            VStack(alignment: .leading, spacing: 16) {
                // 이름
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("이름")
                            .font(.body_14_m)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    HStack {
                        Text("삼색이")
                            .font(.head_18_sb)
                            .foregroundStyle(Color.green500)
                            .padding(.leading, 16)
                    }
                }
                
                // 성별
                VStack(alignment: .leading, spacing: 10) {
                    Text("성별")
                        .font(.body_14_m)
                        .padding(.leading, 16)
                    Text("여아")
                        .font(.head_18_sb)
                        .foregroundStyle(Color.green500)
                        .padding(.leading, 16)
                }
                
                // 중성화
                Text("중성화했어요")
                    .font(.caption_12_sb)
                    .foregroundStyle(Color.gray300)
                    .padding(.leading, 16)
                
                // 견종
                VStack(alignment: .leading, spacing: 10) {
                    Text("견종")
                        .font(.body_14_m)
                        .padding(.leading, 16)
                    Text("길냥이")
                        .font(.head_18_sb)
                        .foregroundStyle(Color.green500)
                        .padding(.leading, 16)
                }
                
                // 나이
                VStack(alignment: .leading, spacing: 10) {
                    Text("나이")
                        .font(.body_14_m)
                        .padding(.leading, 16)
                    Text("12세")
                        .font(.head_18_sb)
                        .foregroundStyle(Color.green500)
                        .padding(.leading, 16)
                }
                
                // 성향
                VStack(alignment: .leading, spacing: 10) {
                    Text("성향")
                        .font(.body_14_m)
                        .padding(.leading, 16)
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("에너지 레벨")
                                .font(.body_14_sb)
                                .foregroundStyle(Color.gray400)
                            Text("활동적이에요")
                                .font(.head_18_sb)
                                .foregroundStyle(Color.green500)
                        }
                        .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("사회성 레벨")
                                .font(.body_14_sb)
                                .foregroundStyle(Color.gray400)
                            Text("낯을 가려요")
                                .font(.head_18_sb)
                                .foregroundStyle(Color.green500)
                        }
                        .padding(.leading, 32)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .topNavigationView {
            BackButton {
                router.pop()
            }
        } center: {
            Text("반려견 프로필")
        }
        
        
    }
}
