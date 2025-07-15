//
//  UserProfileView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/7/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var coordinator: Coordinator<MyPageScene>
    @EnvironmentObject var mainTabViewModel: MainTabViewModel
    
    var body: some View {
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
                    Text("김도기")
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
                Text("여성")
                    .font(.head_18_sb)
                    .foregroundStyle(Color.green500)
                    .padding(.leading, 16)
            }
            
            // 나이
            VStack(alignment: .leading, spacing: 10) {
                Text("나이")
                    .font(.body_14_m)
                    .padding(.leading, 16)
                Text("24세")
                    .font(.head_18_sb)
                    .foregroundStyle(Color.green500)
                    .padding(.leading, 16)
            }
            
            // 활동지역
            VStack(alignment: .leading, spacing: 10) {
                Text("활동지역")
                    .font(.body_14_m)
                    .padding(.leading, 16)
                Text("강남구 역삼동")
                    .font(.head_18_sb)
                    .foregroundStyle(Color.green500)
                    .padding(.leading, 16)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .topNavigationView(left: {
            BackButton {
                coordinator.pop()
                mainTabViewModel.isHidden = false
            }
        }, center: {
            Text("견주 프로필")
                .font(.body_16_sb)
        })
        
    }
}
